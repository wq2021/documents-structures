1. /juicers
2. /juicers/juicer
3. //juicer
4. 
5. ./juicer/@*
6. /juicers/juicer/@*/data()
7. /juicers/juicer/* ou /juicers/juicer/child::*
8. //juicer[@type = "gear"]
9. /juicers/juicer[1]
10. /juicers/juicer[last()]
11. /juicers/juicer[4]/warranty
12. /juicers/juicer[cost < 100]
13. //juicer[not(image)]
14. /juicers/juicer[last()]
15. ancestor::*[last()]
16. count(//*)
17. //*[count(child::*) >= 2] ou //*[child::*[position() >= 2]]
18. //*[2]
19. //name/following-sibling::*[position()=1]/name()
20. //text()[string-length(.) > 140]
21. //juicer/retailer[contains(text(), 'html')]
