package MyApp1::Dispatch;

use base 'CGI::Application::Dispatch';

sub dispatch_args {
	return {
		prefix      => MyApp1::C,
		args_to_new =>{PARAMS =>{cfg_file => $ENV{CONFIG_FILE}}},
		table       => [
			''                   => {app => 'home'},
			':app'               => {},
			':app/:rm/:id?'      => {},
			':app/:rm/:id/:extra1?' => {},

		],
		default => 'home'

	};
}
1;
