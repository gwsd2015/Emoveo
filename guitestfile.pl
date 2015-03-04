use strict;
use Tkx;

my $form = Tkx::widget->new('.');

$form->g_wm_title('test object GUI');

$form->m_configure(-background => "blue");

Tkx::MainLoop();

