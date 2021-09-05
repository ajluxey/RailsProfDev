module FilesUploadService
  def self.update_with_files(resource, params)
    uploaded_files = params.delete(:files)
    files_ids_for_deleting = params.delete(:files_blob_ids)&.reject!(&:empty?)

    resource.transaction do
      if resource.update(params)
        uploaded_files&.each { |file| resource.files.attach(file) }
        ActiveStorage::Attachment.where(id: files_ids_for_deleting)&.each(&:purge)
        resource.reload
      end
    rescue ActiveRecord::RecordInvalid
      false
    else
      true
    end
  end
end
