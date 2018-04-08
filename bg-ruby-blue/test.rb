[ { :splat => [ "/foo" ] }, { :splat => "/foo" } ].each do |params|
    path_info = [*params[:splat]].first
    puts "#{path_info} (#{path_info.class})"
end
