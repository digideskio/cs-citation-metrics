package MyApp;

sub authenticate_api_request {
    my ($next, $c, $action_spec) = @_;
    
    # Go to the action if the Authorization header is valid
    return $next->($c) if $c->req->headers->authorization eq "s3cret!";
    
    # ...or render an error if not
    return $c->render_swagger(
	{errors => [{message => "Invalid authorization key", path => "/"}]},
	{},
	401
	);
}
