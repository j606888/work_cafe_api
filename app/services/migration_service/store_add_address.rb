class MigrationService::StoreAddAddress < Service
  def perform
    ActiveRecord::Base.transaction do
      Store.includes(:sourceable).each do |store|
        source = store.sourceable
        StoreService::CreateFromGoogleApi.new(
          source_type: source.class.to_s,
          source_id: source.id
        ).perform
      end
    end
  end
end
