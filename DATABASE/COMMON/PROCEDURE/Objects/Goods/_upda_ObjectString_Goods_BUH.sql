with tmpAll_1 as (select Object_Goods.*
                  from Object AS Object_Goods
                       join objectProtocol on objectProtocol.Objectid = Object_Goods.Id
                                          AND objectProtocol.OperDate >= '27.07.2021'
                                          AND objectProtocol.UserId = 6131893
                  WHERE Object_Goods.DescId = zc_Object_Goods()
                    and objectProtocol.ProtocolData ilike '%<Field FieldName = "Значение" FieldValue = %'
and Object_Goods.Id = 621849   -- 331529
                 )
   , tmpAll_2 as (select tmpAll_1.*, objectProtocol.UserId, objectProtocol.OperDate, objectProtocol.ProtocolData
                       , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]/@FieldValue', objectProtocol.ProtocolData :: XML) AS TEXT), '\"', 'xxxrepl'), '{', ''), '}',''), '"',''), 'xxxrepl', '"') AS GoodsName_xml
                       , REPLACE(REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]/@FieldValue', objectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}',''), '"','') AS GoodsName_xml_old
                       , CAST (XPATH ('/XML/Field[@FieldName = "Значение"]/@FieldValue', objectProtocol.ProtocolData :: XML) AS TEXT) AS GoodsName_xml2
                       , ROW_NUMBER() OVER (PARTITION BY tmpAll_1.Id ORDER BY objectProtocol.OperDate DESC) AS Ord
                   from tmpAll_1
                        join objectProtocol on objectProtocol.Objectid = tmpAll_1.Id
                   WHERE objectProtocol.ProtocolData ilike '%<Field FieldName = "Значение" FieldValue = %'
                 )
   , tmpAll_modyf as (select Id, max(Ord) as Ord from tmpAll_2 where OperDate >= '27.07.2021' group by Id)

   , tmpAll_check as (select distinct tmpAll_1.* from tmpAll_1 join tmpAll_2 ON tmpAll_2.Id = tmpAll_1.Id and tmpAll_2.OperDate >= '27.07.2021' AND tmpAll_2.UserId <> 6131893)
--  select * from tmpAll_2 where Id = 331529 order by ord

--
select tmpAll_1.Id, tmpAll_1.ValueData AS GoodName_curr, tmpAll_2.GoodsName_xml, GoodsName_xml2, GoodsName_xml_old, tmpAll_2.OperDate
-- , lpInsertUpdate_ObjectString (zc_ObjectString_Goods_BUH(), tmpAll_1.Id, tmpAll_2.GoodsName_xml)
from tmpAll_1
     join tmpAll_modyf ON tmpAll_modyf.Id = tmpAll_1.Id
     left join tmpAll_2 ON tmpAll_2.Id = tmpAll_1.Id
                       AND tmpAll_2.Ord = tmpAll_modyf.Ord + 1
     left join ObjectString  on ObjectString.ObjectId = tmpAll_1.Id and ObjectString.DescId = zc_ObjectString_Goods_BUH()
--  where tmpAll_1.ValueData <> coalesce (tmpAll_2.GoodsName_xml, '')
-- where tmpAll_1.ValueData <> coalesce (tmpAll_2.GoodsName_xml, '')
where  ObjectString.ValueData <> '' and ObjectString.ValueData <> tmpAll_2.GoodsName_xml
 -- where tmpAll_2.Id is null

