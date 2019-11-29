#!/usr/bin/env hy3

(setv conversions {
  "f" 5792 "u" 5794 "th" 5798 "o" 5801 "r" 5809
  "ch" 5811 "c" 5811 "g" 5815 "w" 5817 "v" 5817
  "h" 5819 "n" 5822 "i" 5825 "j" 5828 "yo" 5831
  "p" 5832 "x" 5833 "s" 5835 "t" 5839 "b" 5842
  "e" 5846 "m" 5847 "l" 5850 "ng" 5853 "d" 5854
  "oe" 5855 "a" 5800 "ae" 5803 "y" 5795 "ea" 5856
  "k" 5859 "ga" 5816 "q" 5859
  "F" 5792 "U" 5794 "TH" 5798 "O" 5801 "R" 5809
  "CH" 5811 "C" 5811 "G" 5815 "W" 5817 "V" 5817
  "H" 5819 "N" 5822 "I" 5825 "J" 5828 "YO" 5831
  "P" 5832 "X" 5833 "S" 5835 "T" 5839 "B" 5842
  "E" 5846 "M" 5847 "L" 5850 "NG" 5853 "D" 5854
  "OE" 5855 "A" 5800 "AE" 5803 "Y" 5795 "EA" 5856
  "K" 5859 "GA" 5816 "Q" 5859
  "Th" 5798 "Ch" 5811 "Yo" 5831 "Ng" 5853 "Oe" 5855 
  "Ae" 5803 "Ea" 5856 "Ga" 5816
  "tH" 5798 "cH" 5811 "yO" 5831 "nG" 5853 "oE" 5855 
  "aE" 5803 "eA" 5856 "gA" 5816
})

(import sys)
(defn next-char []
  (sys.stdin.read 1))

(defn print-conversion [s]
  (setv code (.get conversions s))
  (if code (chr code) s))

(import re)
(defn complete-eseq? [so-far]
  (re.fullmatch
    (+ "\x1b(?:"
       "(?:"
         "(?:#\d)|"
         "(?:\dn)|"
         "(?:\d+;\d+R)|"
         "[NO=>DME78HcFGABCD<IJKZ]|"
         "(?:[()][AB012])|"
         "(?:/Z)"
       ")|"
       "(?:"
         "\[(?:"
         "(?:s|u|m|H|;H|f|;f|i|1i|4i|5i|c)|"
         "(?:\d+[ABCDqc])|"
         "(?:\d+;\d+[Hf])|"
         "(?:\d+;\d+;\d+m)|"
         "(?:=\d+[hl])|"
         "(?:..[hl])|"
         "(?:.m)|"
         "(?:.+;.+r)|"
         "(?:\?1;\d+0c)|"
         "(?:2;\d+y)|"
         "(?:.*[JKg])"
       ")))")
    so-far))

(defn convert []
  (setv last (next-char))
  (print (print-conversion last) :end "")
  (while (!= last "")
    (setv this (next-char))

    (when (= this "\x1b")
      (setv so-far this)
      (while (not (complete-eseq? so-far))
        (+= so-far (next-char)))
      (print so-far :end "")
      (sys.stdout.flush)
      (setv last None)
      (continue))

    (print
      (if (and last
                (.get conversions (+ last this)))
        f"\b{(print-conversion (+ last this))}"
        (print-conversion this))
      :end "")

    (setv last this)
    (sys.stdout.flush)))

(try
  (convert)
  (except [e Exception]
    (print e)
    (exit)))
