class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_service_file
    template "service.rb.erb", "app/services/#{service_dirs.join('/')}/#{file_name}.rb"
  end

  def create_spec
    template "service.spec.rb.erb", "spec/services/#{service_dirs.join('/')}/#{file_name}_spec.rb"
  end

  private

  def service_dirs
    ([name.split('/')[0].underscore + "_service"] + name.split('/')[1..-2].map(&:underscore))
  end

  def service_namespaces_camel
    service_dirs.map(&:camelize).join('::')
  end

  def service_name_camel
    name.split('/')[-1].camelize
  end

  def service_full_class
    "#{service_namespaces_camel}::#{service_name_camel}"
  end

end
