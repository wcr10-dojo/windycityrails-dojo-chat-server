WindycityrailsDojoChatServer::Application.routes.draw do
  root :to => "chat#index"

  #TODO:  Too lame for the Dojo!
  match ':controller(/:action(/:id(.:format)))'
end
