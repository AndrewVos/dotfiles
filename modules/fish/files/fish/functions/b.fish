# Defined via `source`
function b --wraps='bundle exec' --description 'alias b bundle exec'
  bundle exec $argv; 
end
