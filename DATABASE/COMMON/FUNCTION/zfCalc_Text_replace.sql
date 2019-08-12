-- Function: zfCalc_Text_replace

DROP FUNCTION IF EXISTS zfCalc_Text_replace (Text, Text, Text);

CREATE OR REPLACE FUNCTION zfCalc_Text_replace(
    IN inText        Text,
    IN inFromText    Text,
    IN inToText      Text
)
RETURNS Text
AS
$BODY$
   DECLARE vbIndex  Integer;
BEGIN

    -- RETURN REPLACE (inText, inFromText, inToText);

    vbIndex:= POSITION (LOWER (inFromText) IN LOWER (inText));
    
    IF vbIndex > 0
    THEN
        inText:= OVERLAY (inText PLACING COALESCE (inToText, '') FROM vbIndex FOR LENGTH (inFromText));
        --
        IF POSITION (LOWER (inFromText) IN LOWER (inText)) > 0
        THEN RETURN zfCalc_Text_replace(inText,inFromText, inToText);
        ELSE RETURN inText;
        END IF;
        
    ELSE
        RETURN inText;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.19                                        *
*/

/*
-- update Object set ValueData= newValueData from (
SELECT Object.Id, Object.ValueData, zfCalc_Text_replace (Object.ValueData, 'м.Дніпропетровськ ', 'м.Дніпро ') as newValueData
FROM Object 
     inner join ObjectDesc on ObjectDesc.Id = Object.DescId
 where Object.ValueData ilike '%Дніпропетровськ%'
-- where Object.ValueData ilike '%пропетровськ%' -- and not Object.ValueData ilike '%Дніпропетровськ%'
and ObjectDesc.Code not in ('zc_Object_Bank', 'zc_Object_GoodsProperty', 'zc_Object_Juridical'
--  , 'zc_Object_Partner'
 , 'zc_Object_RouteSorting', 'zc_Object_ContractDocument', 'zc_Object_Partner1CLink', 'zc_Object_City')
and ObjectDesc.Code in ('zc_Object_Partner')
order by Object.DescId, Object.ValueData
-- ) as a where a.Id = Object.Id


-- update ObjectString set ValueData= newValueData from (
SELECT ObjectString.*, zfCalc_Text_replace (ObjectString.ValueData, 'м.Дніпропетровськ,', 'м.Дніпро,') as newValueData
FROM Object 
     inner join ObjectDesc on ObjectDesc.Id = Object.DescId
     inner join ObjectString on ObjectString.ObjectId = Object.Id
     inner join ObjectStringDesc on ObjectStringDesc.Id = ObjectString.DescId
 where ObjectString.ValueData ilike '%Дніпропетровськ%'
-- where ObjectString.ValueData ilike '%пропетровськ%'
-- and ObjectDesc.Code not in ('zc_Object_Bank', 'zc_Object_GoodsProperty', 'zc_Object_Juridical', 'zc_Object_Partner', 'zc_Object_RouteSorting', 'zc_Object_ContractDocument', 'zc_Object_Partner1CLink')
-- and ObjectStringDesc.Code not in ('zc_ObjectString_Partner_NameInteger') -- 'zc_ObjectString_Partner_Address'
order by Object.DescId, Object.ValueData
-- ) as a where a.ObjectId = ObjectString.ObjectId  and  a.DescId = ObjectString.DescId 
*/
-- тест
-- SELECT * FROM zfCalc_Text_replace ('123aaa456', 'aaa', '0'), REPLACE ('123aaa456', 'aaa', '0');
