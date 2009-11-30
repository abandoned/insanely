module AssetsHelper
  def setup_assets(parent)
    returning(parent) do |p|
      p.assets.build if p.assets.empty? || !p.assets.last.new_record?
    end
  end
end
