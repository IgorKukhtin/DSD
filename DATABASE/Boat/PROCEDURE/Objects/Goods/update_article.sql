--update ObjectString set valueData = valueData_new
--from (
select * 
, case when ObjectString_Article.ValueData ilike '%-01-03' then zfCalc_Text_replace (ObjectString_Article.ValueData, '-01-03', '-03-οτ')
       when ObjectString_Article.ValueData ilike '%-01-02' then zfCalc_Text_replace (ObjectString_Article.ValueData, '-01-02', '-02-οτ')
       when ObjectString_Article.ValueData ilike '%-01-01' then zfCalc_Text_replace (ObjectString_Article.ValueData, '-01-01', '-01-οτ')
  end as valueData_new
, ObjectString_Article.ObjectId as Id_ok
from Object
          JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                AND (ObjectString_Article.ValueData ilike '%-01-03'
or ObjectString_Article.ValueData ilike '%-01-02'
or ObjectString_Article.ValueData ilike '%-01-01')

where Object.DescId = zc_Object_Goods()
order by ObjectCode desc
--) as xxx
--where ObjectString.DescId = zc_ObjectString_Article()
--and ObjectString.ObjectId = Id_ok
