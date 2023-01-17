 update ObjectProtocol set ProtocolData = newData
 from (
select findTxt1, findTxt2
-- , SUBSTRING (ProtocolData  , 250, 250) as oldData
-- , SUBSTRING (Replace (ProtocolData  , findTxt2 , '***'), 250, 250) as newData_test
 , zfCalc_Text_replace (ProtocolData  , findTxt2, '***') as newData
--  , POSITION (LOWER (findTxt2) IN LOWER (ProtocolData))
, Id, ProtocolData
from
(
select SUBSTRING (findTxt1, 2, LENGTH (findTxt1) - 2) as findTxt2
, * 
-- select count(*)
from
(select xpath('/XML/Field[@FieldName = "Пароль пользователя"]/@FieldValue', ProtocolData :: XML) :: Text as findTxt1
, ObjectProtocol.*
from ObjectProtocol -- (ObjectId, OperDate, UserId, ProtocolData, isInsert)
join Object on Object.Id = ObjectProtocol.ObjectId
JOIN ObjectBoolean AS ObjectBoolean_ProjectAuthent
                                ON ObjectBoolean_ProjectAuthent.ObjectId = ObjectProtocol.ObjectId
                               AND ObjectBoolean_ProjectAuthent.DescId = zc_ObjectBoolean_User_ProjectAuthent()
                               AND ObjectBoolean_ProjectAuthent.ValueData = true
and Object.DescId = zc_Object_User()
and Object.Id <> 5
where ProtocolData ilike '%Пароль пользователя%'
 
) as aa
) as aa
where findTxt2 <> '""'
 and findTxt2 <> '***'

 ) as aa where ObjectProtocol.Id = aa.Id
