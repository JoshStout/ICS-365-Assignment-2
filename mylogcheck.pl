#!/usr/bin/perl

#open file
open(FILE,$ARGV[2]) or die("Could not open the file $ARGV[2]");

$flag = 0; #user found flag

#loop thru contents of file and add to variables
while ( $line = <FILE> ) {

        #place each column in its own variable
        ($loginID, $term, $ip, $dayOfweek, $month, $day, $start, $dash, $end, $time) = split(' ', $line);

        #test for cmdline options: -c is ip class, -u is for loginID
        if ( $ARGV[0] eq "-c" ){
                #test first octet for ip class
                ($IPclass) = split('\.', $ip);
                if ( $IPclass > 0 && $IPclass < 127 && $ARGV[1] eq "A" ){
                        print $line;
                }
                if ( $IPclass > 127 && $IPclass <= 191 && $ARGV[1] eq "B" ){
                        print $line;
                }
                if ( $IPclass > 191 && $IPclass <= 223 && $ARGV[1] eq "C" ){
                        print $line;
                }
        }
        if ( $ARGV[0] eq "-u" && $line =~ $ARGV[1] ){
                if ( $flag == 0 ){
                        print "\nLogin records for $ARGV[1]:\n\n";
                }
                $flag = 1;
                print $line;
                $n++;
                $time =~ tr/()/ /;
                ($hours, $mins) = split(':', $time);
                $totalHours = $totalHours + $hours;
                $totalMins = $totalMins + $mins;
        }
}
if ( $ARGV[0] eq "-u" ){
        if ( $n > 0 ){
                $quotient = int($totalMins / 60);
                $totalHours = $totalHours + $quotient;
                if ($totalHours > 1 ){
                        $x = "s";
                } else {
                        $x = "";
                }
                $totalMins = $totalMins % 60;
                print "\n$ARGV[1] has spent $totalHours hour$x and $totalMins minutes on the system.\n\n";
        }
        if ( $n == 0 ){
                print "\nNo login record has been found for $ARGV[1].\n\n";
        }
}
