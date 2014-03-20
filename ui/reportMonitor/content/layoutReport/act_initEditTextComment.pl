# Get TextComment
$editHeaderText = "Edit Text Comment";
$contentID = $request->param('contentID');
my $contentArray = $reportObject->getContentArray();
my $contentStruct = $contentArray->[$contentID];
$textComment = $contentStruct->{'textComment'};
1;