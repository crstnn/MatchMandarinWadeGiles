BEGIN {
	# The higher level structure is delimited by a colon but the colon may appear multiple times
	FS = ":";
	
	# Count of name that does not belong to Mandarin Wade-Giles but is matched by the regular expression
    falsePosCount = 0;
	
	# Count of that belongs to Mandarin Wade-Giles but is NOT matched by the regular expression.
    falseNegCount = 0;
	
	matchCount = 0;
    nonMatchCount = 0;
	
	# Below regex constructed with sed
	nameRegex = "^((((p|p'|m|f|t|t'|n|l|k|k'|h|ch|ch'|hs|sh|j|ts|ts'|s|w|y)(a|i|o|u|ai|an|ao|eh|ei|en|ia|ih|in|iu|ou|ua|ui|un|uo|ang|eng|iao|ieh|ien|ing|uai|uan|ueh|uei|ung|iang|iung|uang))|(ai|ei|ao|ou|an|ang|en|eng|erh)) ((p|p'|m|f|t|t'|n|l|k|k'|h|ch|ch'|hs|sh|j|ts|ts'|s|w|y)(a|i|o|u|ai|an|ao|eh|ei|en|ia|ih|in|iu|ou|ua|ui|un|uo|ang|eng|iao|ieh|ien|ing|uai|uan|ueh|uei|ung|iang|iung|uang)|(ai|ei|ao|ou|an|ang|en|eng|erh))(([- ]((p|p'|m|f|t|t'|n|l|k|k'|h|ch|ch'|hs|sh|j|ts|ts'|s|w|y)(a|i|o|u|ai|an|ao|eh|ei|en|ia|ih|in|iu|ou|ua|ui|un|uo|ang|eng|iao|ieh|ien|ing|uai|uan|ueh|uei|ung|iang|iung|uang)|(ai|ei|ao|ou|an|ang|en|eng|erh)))?))$";
	wadeGilesRegex = "MandarinWadeGiles$";
}
{
	name = tolower($1);
    if(name ~ nameRegex){
		if($NF ~ wadeGilesRegex){
			matchCount++;
		}
		else{
			falsePosCount++;
		}
	} 
	else {
		if($NF ~ wadeGilesRegex){
			falseNegCount++;
		}
		else{
			nonMatchCount++;
		}
	}
	
}
END {
    print "Number of False Positives: " falsePosCount;
    print "Number of False Negatives: " falseNegCount;
	print "Number of True Positives (Correct Matches): " matchCount;
    print "Number of True Negatives (Correct Non-Matches): " nonMatchCount;
}