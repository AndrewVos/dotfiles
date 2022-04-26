# Defined via `source`
function ls --wraps='exa -l' --description 'alias ls exa -l'
  exa -l $argv; 
end
