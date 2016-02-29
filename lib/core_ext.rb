class Dir
  def self.globi(path)
    Dir.glob(path, File::FNM_CASEFOLD)
  end
end
