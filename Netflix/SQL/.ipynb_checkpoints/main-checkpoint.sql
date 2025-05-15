--remove duplicates 
select show_id, COUNT(*) 
from netflix_titles
group by show_id 
having COUNT(*)>1


SELECT n.* 
FROM netflix_titles n
JOIN (
    SELECT UPPER(title) AS utitle, type
    FROM netflix_titles
    GROUP BY UPPER(title), type
    HAVING COUNT(*) > 1
) dup ON UPPER(n.title) = dup.utitle AND n.type = dup.type
ORDER BY n.title;