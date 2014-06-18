Dir[Rails.root.join('app/workflows/*')].sort.each do |workflow_file|
  load workflow_file
end
