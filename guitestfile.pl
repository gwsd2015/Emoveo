use strict;
use Tkx;

my $form = Tkx::widget->new('.');

$form->g_wm_title('test object GUI');

$form->m_configure(-background => "blue");

$form->g_wm_minsize(1200, 480);

my $button;

$button = $form->new_button(
	-text => "Hello, world",
	-command => sub{
		$button->m_configure(
			-text => "Goodbye, cruel world",
			
		);
	Tkx::after(1500, sub {$form->g_destroy});
	},
);

$button->g_pack(
	-padx => 150,
	-pady => 150,
);

Tkx::tk___messageBox(
	-parent => $form,
	-icon => "info",
	-title => "Tip of the Day",
	-message => "Please be nice!",
);


Tkx::MainLoop();

