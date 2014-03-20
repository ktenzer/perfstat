package PerfStatCGI::Session;

use strict;
use Digest::MD5;
use Storable qw(lock_store lock_retrieve);

#_______________________________________________________________
# Constructor
sub new
{
	my $this = {};
	my $class = shift;
	my ($arg1, $arg2, $arg3) = @_;
	bless ($this, $class);
	$this->{driver} = $arg1;
	$this->{claimedID} = $arg2;
	$this->{storageDirectory} = $arg3->{Directory};
	$this->{data} = {};
	$this->doInit();
	return $this;
}

# Create a new session or regenerate an old one
sub doInit()
{
	my $self = shift;
	my $returnValueCheck;

	if (defined($self->{claimedID})) {
		$returnValueCheck = $self->_initOldSession();		
		if (!defined($returnValueCheck)) {
			return $self->_initNewSession();
		} else {
			return $returnValueCheck;
		}

	} else {
		return $self->_initNewSession();
	}
}

sub _initOldSession()
{
	my $self = shift;
	my $data = $self->_retrieve();
	# Session was initialized successfully
	if (defined($data)) {
		$self->{data} = $data;
		
		# Does IP of the initial session owner match with the current user's IP
		if ($self->{data}->{_sessionRemoteAddress} ne $ENV{REMOTE_ADDR}) {
			$self->delete();
			return undef;
		}
	
		$self->{data}->{_sessionATime} = time();
		return 1;

	} else {
		return undef;
	}
}

sub _initNewSession()
{
	my $self = shift;
	my $currtime = time();
	$self->{data}->{_sessionID} = $self->generateID();
	$self->{data}->{_sessionCTime} = $currtime;
	$self->{data}->{_sessionATime} = $currtime;
	$self->{data}->{_sessionTTL} = undef;
	$self->{data}->{_sessionRemoteAddress} = $ENV{REMOTE_ADDR} || undef;

	return 1;
}

# Generate a unique id
sub generateID()
{
    my $self = shift;

    my $md5 = new Digest::MD5();
    $md5->add($$ , time() , rand(9999) );

    return $md5->hexdigest();
}

#_______________________________________________________________
# Get and Set Functions
sub param() 
{
	my $self = shift;

	if ( @_ == 1 )
	{
		return $self->_getParam(@_);
	}
	elsif ( @_ == 2 ) 
	{
		return $self->_setParam(@_);
	}
	else
	{
		die("illegal number of arguments");
	}
}

# gets a single parameter
sub _getParam()
{
	my ($self, $key) = @_;
	return $self->{data}->{$key};
}


# sets a single parameter
sub _setParam()
{
	my ($self, $key, $value) = @_;

	$self->{data}->{$key} = $value;
	return $value;
}

#_______________________________________________________________
# Return SessionID
sub id()
{
    my $self = shift;
    return $self->{data}->{_sessionID};
}

#_______________________________________________________________
# FILE level functions
sub _retrieve()
{
	my $self = shift;

	if (-e "$self->{storageDirectory}/$self->{claimedID}.ser") {
		return lock_retrieve("$self->{storageDirectory}/$self->{claimedID}.ser");
	} else {
		return undef;
	}
}

sub store()
{
	my $self = shift;
	lock_store($self->{data}, "$self->{storageDirectory}/$self->{data}->{_sessionID}.ser") 
		|| die("Can't store session data in $self->{storageDirectory}/$self->{data}->{_sessionID}.ser");
	return 1;
}

sub remove()
{
	my $self = shift;
	unlink("$self->{storageDirectory}/$self->{data}->{_sessionID}.ser") 
		|| die("Can't unlink session file: $self->{storageDirectory}/$self->{data}->{_sessionID}.ser\n");
	return 1;
}
1;