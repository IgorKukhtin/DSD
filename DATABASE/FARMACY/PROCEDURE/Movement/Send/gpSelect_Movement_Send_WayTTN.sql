-- Function: gpSelect_Movement_Send_WayTTN()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_WayTTN(TVarChar, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_WayTTN(
    IN inWayName         TVarChar  , -- Напревление    
    IN inDataJson        Text      , -- json Данные    
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (ObjectCode         Integer,
               Name               TVarChar,
               Amount             TFloat,
               Price		      TFloat,
               Summ               TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF inDataJson = '[]'
  THEN
    RAISE EXCEPTION 'Данные с базы не загружены.';
  END IF;

  
  -- из JSON в таблицу
  CREATE TEMP TABLE tblDataJSON
  (
     Id              Integer
  ) ON COMMIT DROP;

  INSERT INTO tblDataJSON
  SELECT *
  FROM json_populate_recordset(null::tblDataJSON, replace(replace(replace(inDataJson, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);

  -- Результат
  RETURN QUERY
  WITH tmpMovementAll AS (SELECT DISTINCT tblDataJSON.id
                          FROM tblDataJSON) 
     , tmpMovement AS (SELECT Movement.id
                            , REPLACE(COALESCE (Object_ProvinceCity_From.ValueData, Object_Area_From.ValueData, '')||' - '||
                              COALESCE (Object_ProvinceCity_To.ValueData, Object_Area_To.ValueData, ''), 'г. ', '') AS WayName
                       FROM tmpMovementAll AS tblDataJSON 
                       
                            INNER JOIN Movement ON Movement.Id = tblDataJSON.Id

                            /*INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                       ON MovementBoolean_SUN.MovementId = Movement.Id
                                                      AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                      AND MovementBoolean_SUN.ValueData = TRUE*/

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Area_From
                                                 ON ObjectLink_Unit_Area_From.DescId = zc_ObjectLink_Unit_Area()
                                                AND ObjectLink_Unit_Area_From.ObjectId = MovementLinkObject_From.ObjectId
                             LEFT JOIN Object AS Object_Area_From
                                             ON Object_Area_From.Id = ObjectLink_Unit_Area_From.ChildObjectId
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity_From
                                                 ON ObjectLink_Unit_ProvinceCity_From.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                                AND ObjectLink_Unit_ProvinceCity_From.ObjectId = MovementLinkObject_From.ObjectId
                            LEFT JOIN Object AS Object_ProvinceCity_From
                                             ON Object_ProvinceCity_From.Id = ObjectLink_Unit_ProvinceCity_From.ChildObjectId
                                            AND Object_ProvinceCity_From.ValueData ILIKE 'г.%'
 
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Area_To
                                                 ON ObjectLink_Unit_Area_To.DescId = zc_ObjectLink_Unit_Area()
                                                AND ObjectLink_Unit_Area_To.ObjectId = MovementLinkObject_To.ObjectId
                            LEFT JOIN Object AS Object_Area_To
                                             ON Object_Area_To.Id = ObjectLink_Unit_Area_To.ChildObjectId
                            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity_To
                                                 ON ObjectLink_Unit_ProvinceCity_To.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                                AND ObjectLink_Unit_ProvinceCity_To.ObjectId = MovementLinkObject_To.ObjectId
                            LEFT JOIN Object AS Object_ProvinceCity_To
                                             ON Object_ProvinceCity_To.Id = ObjectLink_Unit_ProvinceCity_To.ChildObjectId
                                            AND Object_ProvinceCity_To.ValueData ILIKE 'г.%'
 
                       WHERE COALESCE (Object_ProvinceCity_From.Id, Object_Area_From.Id, 0) <> COALESCE (Object_ProvinceCity_To.Id, Object_Area_To.Id, 0)
                       ),
       tmpMI AS (SELECT Movement.*
                      , MovementItem.Id
                      , MovementItem.ObjectId    AS GoodsId
                      , MovementItem.Amount
                      , MIFloat_Price.ValueData                       AS Price
                      , MovementItem.Amount * MIFloat_Price.ValueData AS Summ
                 FROM tmpMovement AS Movement
 
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.isErased = False
                                             AND MovementItem.DescId = zc_MI_Master()
                                             AND MovementItem.Amount > 0
 
                      LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                       AND MIFloat_Price.DescId = zc_MIFloat_PriceFrom()
                                                       
                 WHERE Movement.WayName = inWayName
                 )

   SELECT Object_Goods_Main.ObjectCode
        , Object_Goods_Main.Name
        , sum(tmpMI.Amount)::TFloat                                                    AS Amount
        , ROUND(sum(tmpMI.Summ) / sum(tmpMI.Amount), 2)::TFloat                        AS Price
        , (ROUND(sum(tmpMI.Summ) / sum(tmpMI.Amount), 2) * sum(tmpMI.Amount))::TFloat  AS Summ
   FROM tmpMI

        LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpMI.GoodsId
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId

   GROUP BY Object_Goods_Main.ObjectCode
          , Object_Goods_Main.Name
   ORDER BY Object_Goods_Main.Name;
                             
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 13.04.22                                                                    *
*/

-- тест 

select * from gpSelect_Movement_Send_WayTTN(inWayName := 'Днепр - Каменское', inDataJson := '[{"id":27448252},{"id":27448302},{"id":27448385},{"id":27448532},{"id":27448628},{"id":27448670},{"id":27448735},{"id":27448790},{"id":27448833},{"id":27448858},{"id":27448917},{"id":27448942},{"id":27448984},{"id":27449051},{"id":27449116},{"id":27449141},{"id":27449231},{"id":27449268},{"id":27449297},{"id":27449408},{"id":27449464},{"id":27449471},{"id":27449556},{"id":27449614},{"id":27449619},{"id":27449668},{"id":27449723},{"id":27449727},{"id":27449734},{"id":27449761},{"id":27449793},{"id":27449799},{"id":27449873},{"id":27449912}]' ,  inSession := '3');

