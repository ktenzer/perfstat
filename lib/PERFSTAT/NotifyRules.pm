package NotifyRules;
require Storable;
@ISA = ("Storable");

sub new
{
	my $this = {};
	bless ($this, shift);
	$this->doInit(@_);
	return $this;
}

sub doInit
{
	my ($this, %arg) = @_;
	$this->{notifyRulesArray} = $arg{notifyRulesArray} || [];
}

sub addNotifyRulesArray
{
        my ($this, $arg) = @_;
        $arrayRef = $this->{notifyRulesArray};
        push(@$arrayRef, $arg);
}

sub deleteNotifyRulesArray
{
        my ($this, $skipElements) = @_;
        $arrayRef = $this->{'notifyRulesArray'};
        splice(@$arrayRef, $skipElements, 1);
}

sub deleteAllRules
{
  my ($this) = @_;
  $arrayRef = $this->{'notifyRulesArray'};
  splice(@$arrayRef, 0);
}

sub updateNotifyRulesArray
{
	my ($this, $contentID, $notifyRule) = @_;
  $arrayRef = $this->{notifyRulesArray};
  $arrayRef->[$contentID] = $notifyRule;
}

sub getNotifyRulesArray
{
        my $this = shift @_;
        my $arrayRef = $this->{notifyRulesArray};
        return $arrayRef;
}

sub getNotifyRulesArrayLength
{
        my $this = shift @_;
        my $arrayRef = $this->{notifyRulesArray};
        my $arrayLength = @$arrayRef;
        return $arrayLength;
}

1; #terminate the package
