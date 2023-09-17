require 'flipper/adapters/active_record'


Flipper.register(:admins) do |actor, context|
  actor.respond_to?(:admin?) && actor.admin?
end