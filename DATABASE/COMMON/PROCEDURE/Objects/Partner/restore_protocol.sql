with tmp1 as 
(SELECT Object .* 
FROM Object 
 join objectProtocol on objectProtocol.Objectid = Object.Id
    and objectProtocol.OperDate >= '20.05.2022' 

WHERE Object.DescId = zc_Object_Partner()
)

, tmp2 as 
(SELECT Object .* 
     , objectProtocol.Id as Id_pr
, REPLACE(REPLACE(XPATH ('/XML/Field[@FieldName = "Код"]/@FieldValue', objectProtocol.protocolData :: XML) :: Text, '{', ''), '}','') AS X
         , ROW_NUMBER() OVER (PARTITION BY Object.Id ORDER BY objectProtocol.Id ASC) AS Ord
, objectProtocol.protocolData

FROM tmp1 AS Object 
 join objectProtocol on objectProtocol.Objectid = Object.Id

-- and objectProtocol.OperDate >= '23.05.2022' 

)

select * from tmp2

