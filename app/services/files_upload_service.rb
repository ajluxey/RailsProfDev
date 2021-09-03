module FilesUploadService
  def self.update_with_files(resource, params)
    uploaded_files = params.delete(:files)
    files_ids_for_deleting = params.delete(:files_blob_ids)
    files_ids_for_deleting.reject!(&:empty?) if files_ids_for_deleting.present?

    resource.transaction do
      if resource.update(params)
        uploaded_files.each { |file| resource.files.attach(file) } if uploaded_files.present?
        resource.files.find(files_ids_for_deleting).each(&:purge) if files_ids_for_deleting.present?
        resource.reload
      end
    rescue ActiveRecord::RecordInvalid
      false
    else
      true
    end
  end
end
