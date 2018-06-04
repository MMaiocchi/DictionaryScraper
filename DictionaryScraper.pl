#!/usr/bin/perl -w
use strict;
use warnings;

# The following is a simple Perl script to retrieve and format data from the ePSD(http://psd.museum.upenn.edu/epsd/ ).
#This script must placed in and runned from your local ePSD folder.
#To get your off-line version of the ePSD you can use a freewebsite grabber, such as Getleft(http://personal.telefonica.terra.es/web/getleft/ ).
#The script produces an html file named sign_list.html, wich may later be imported in aword processor, such as Open Office Writer (freely available athttp://www.openoffice.org/product/writer.html), for further formatting.


#Note: DOS syntax to get the file list should be changed according to the actual OS
my @filelist = system ('dir *.* /b /on /s /w > allfiles.txt') || die "Error getting the filelist!\n\n";
open (SIGN_LIST, ">sign_list.html");
my @head_etc = "<\?xml version=\"1.0\" encoding\=\"utf-8\"\?>\n<\!DOCTYPE html PUBLIC \"-\/\/W3C\/\/DTDXHTML 1\.0 Strict\/\/EN\" \"http\:\/\/www\.w3\.org\/TR\/xhtml1\/DTD\/xhtml1\-strict\.dtd\">\n<htmlxmlns\=\"http\:\/\/www\.w3\.org\/1999\/xhtml\" lang=\"sux\" xml\:lang\=\"sux\">\n<head>\n <meta http\-equiv\=\"Content-Type\" content\=\"text\/html\; charset\=utf\-8\" \/>\n<title>A SIGN LIST AND SILLABARY FORTHE STUDY OF THIRD MILLENNIUM CUNEIFORM INSCRIPTIONS</title>\n<link rel\=\"shortcut icon\"type\=\"image\/ico\" href=\"\/favicon\.ico\" \/>\n<link rel\=\"stylesheet\" type\=\"text\/css\" href\=\"\.\./\.\./\.\./cbd\.css\" \/>\n<script src\=\"\.\.\/\.\.\/\.\.\/cbd\.js\" type\=\"text\/javascript\"><\![CDATA[]]><\/script>\n<\/head>\n<body>\n\n<table>\n<tr>\n\t<td>No</td\>\n\t<td>VARIANT</td>\n\t<td>SIGNNAME</td>\n\t<td>READINGS</td>\n\t<td>ADDITIONAL READINGS</td>\n</tr>\n";
print SIGN_LIST "@head_etc";
my $count = 1;
foreach my $line (@filelist) {
    chomp $line;
    open (FILE, $line);
    my $space = " ";
    my @file = <FILE>;
    my $img_URL = "";
    my $sign_name = "";
    my $readings = "";
    my $also = "";
    for (my $n=0; $n<=$#file; $n++) {
        if ($file[$n]=~ m/(\<img alt\="cuneiform .+ \/\>)/) {
            $img_URL = $1;
        };
        if ($file[$n]=~ m/<h1 class\=\"psl\">(.+)\<\/h1\>/) {#print "SIGN NAME: $1\n";
            $sign_name = $1;
            print "processing sign $count: $sign_name\n";
        };
        if ($file[$n]=~ m/\<span class\=\"psl-ahead\"\>(.+)<\/span\>(\)?)/) {
            $readings = $readings.$1.$2.$space;
            $readings =~ s/\<span class\=\"psl\-aaka\"\>//ig;
            $readings =~ s/\<\/span\>//ig;
        };
    
        if ($file[$n]=~ m/\<p class\=\"psl-more\"\>\<span class\=\"psl\-hinline\"\>(.+)\./) {
            $also = $1;
            $also =~ s/\<span class\=\"psl\-aaka\"\>//ig;
            $also =~ s/\<\/span\>//ig;
        };
    };
    print SIGN_LIST"<tr>\n\t<td>\[$count\]</td>\n\t<td>$img_URL</td>\n\t<td>$sign_name</td>\n\t<td>$readings</td>\n\t<td>$also</td>\n</tr>";
    $count++;
    close (FILE);
    };
print SIGN_LIST "<\/table>\n<\/body>\n<\/html>";
close (SIGN_LIST);