-- Function: gpReport_FinalSUAProtocol()

DROP FUNCTION IF EXISTS gpReport_FinalSUAProtocol (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_FinalSUAProtocol(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE Cursor3 refcursor;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;


     OPEN Cursor1 FOR
      SELECT Object_FinalSUAProtocol.Id                         AS Id
           , ObjectDate_OperDate.ValueData                      AS OperDate
           , Object_User.ObjectCode                             AS UserCode
           , Object_User.ValueData                              AS UserName

           , ObjectDate_DateStart.ValueData                     AS DateStart
           , ObjectDate_DateEnd.ValueData                       AS DateEnd
           
           , ObjectFloat_Threshold.ValueData                    AS Threshold
           , ObjectFloat_DaysStock.ValueData                    AS DaysStock
           , ObjectFloat_CountPharmacies.ValueData              AS CountPharmacies
           , ObjectFloat_ResolutionParameter.ValueData          AS ResolutionParameter
           
           , ObjectBoolean_GoodsClose.ValueData                 AS isGoodsClose
           , ObjectBoolean_MCSIsClose.ValueData                 AS isMCSIsClose
           , ObjectBoolean_NotCheckNoMCS.ValueData              AS isNotCheckNoMCS
           , COALESCE(ObjectBoolean_MCSValue.ValueData, False)  AS isMCSValue
           , COALESCE(ObjectBoolean_Remains.ValueData, False)   AS isRemains
           
      FROM Object AS Object_FinalSUAProtocol
      
            INNER JOIN ObjectDate AS ObjectDate_OperDate
                                  ON ObjectDate_OperDate.ObjectId = Object_FinalSUAProtocol.Id
                                 AND ObjectDate_OperDate.DescId = zc_ObjectDate_FinalSUAProtocol_OperDate()

            LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_FinalSUAProtocol_User()
            LEFT JOIN Object AS Object_User ON Object_User.ID = ObjectLink_User.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                 ON ObjectDate_DateStart.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectDate_DateStart.DescId = zc_ObjectDate_FinalSUAProtocol_DateStart()
            LEFT JOIN ObjectDate AS ObjectDate_DateEnd
                                 ON ObjectDate_DateEnd.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectDate_DateEnd.DescId = zc_ObjectDate_FinalSUAProtocol_DateEnd()

            LEFT JOIN ObjectFloat AS ObjectFloat_Threshold
                                  ON ObjectFloat_Threshold.ObjectId = Object_FinalSUAProtocol.Id
                                 AND ObjectFloat_Threshold.DescId = zc_ObjectFloat_FinalSUAProtocol_Threshold()
            LEFT JOIN ObjectFloat AS ObjectFloat_DaysStock
                                  ON ObjectFloat_DaysStock.ObjectId = Object_FinalSUAProtocol.Id
                                 AND ObjectFloat_DaysStock.DescId = zc_ObjectFloat_FinalSUAProtocol_DaysStock()
            LEFT JOIN ObjectFloat AS ObjectFloat_CountPharmacies
                                  ON ObjectFloat_CountPharmacies.ObjectId = Object_FinalSUAProtocol.Id
                                 AND ObjectFloat_CountPharmacies.DescId = zc_ObjectFloat_FinalSUAProtocol_CountPharmacies()
            LEFT JOIN ObjectFloat AS ObjectFloat_ResolutionParameter
                                  ON ObjectFloat_ResolutionParameter.ObjectId = Object_FinalSUAProtocol.Id
                                 AND ObjectFloat_ResolutionParameter.DescId = zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsClose
                                    ON ObjectBoolean_GoodsClose.ObjectId = Object_FinalSUAProtocol.Id
                                   AND ObjectBoolean_GoodsClose.DescId = zc_ObjectBoolean_FinalSUAProtocol_GoodsClose()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_MCSIsClose
                                    ON ObjectBoolean_MCSIsClose.ObjectId = Object_FinalSUAProtocol.Id
                                   AND ObjectBoolean_MCSIsClose.DescId = zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCheckNoMCS
                                    ON ObjectBoolean_NotCheckNoMCS.ObjectId = Object_FinalSUAProtocol.Id
                                   AND ObjectBoolean_NotCheckNoMCS.DescId = zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_MCSValue
                                    ON ObjectBoolean_MCSValue.ObjectId = Object_FinalSUAProtocol.Id
                                   AND ObjectBoolean_MCSValue.DescId = zc_ObjectBoolean_FinalSUAProtocol_MCSValue()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Remains
                                    ON ObjectBoolean_Remains.ObjectId = Object_FinalSUAProtocol.Id
                                   AND ObjectBoolean_Remains.DescId = zc_ObjectBoolean_FinalSUAProtocol_Remains()
            
      WHERE Object_FinalSUAProtocol.DescId = zc_Object_FinalSUAProtocol()
        AND Object_FinalSUAProtocol.isErased = False
        AND ObjectDate_OperDate.ValueData >= inStartDate
        AND ObjectDate_OperDate.ValueData < inEndDate + INTERVAL '1 DAY'
      ORDER BY ObjectDate_OperDate.ValueData DESC
      ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
      SELECT Object_FinalSUAProtocol.Id     AS Id
           , tmpUnit.Code                   AS RecipientCode
           , tmpUnit.Name                   AS RecipientName
           
      FROM Object AS Object_FinalSUAProtocol
      
           INNER JOIN ObjectDate AS ObjectDate_OperDate
                                 ON ObjectDate_OperDate.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectDate_OperDate.DescId = zc_ObjectDate_FinalSUAProtocol_OperDate()
                               
           INNER JOIN ObjectBlob AS ObjectBlob_Recipient
                                 ON ObjectBlob_Recipient.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectBlob_Recipient.DescId = zc_objectBlob_FinalSUAProtocol_Recipient()

           INNER JOIN (SELECT T1.Id, T1.Code, T1.Name FROM gpSelect_Object_Unit (True, inSession) AS T1) AS tmpUnit
                                ON ','||ObjectBlob_Recipient.ValueData||',' LIKE '%,'||tmpUnit.Id::TVarChar||',%'
            
      WHERE Object_FinalSUAProtocol.DescId = zc_Object_FinalSUAProtocol()
        AND Object_FinalSUAProtocol.isErased = False
        AND ObjectDate_OperDate.ValueData >= inStartDate
        AND ObjectDate_OperDate.ValueData < inEndDate + INTERVAL '1 DAY'
      ORDER BY Object_FinalSUAProtocol.Id, tmpUnit.Name
      ;

     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
      SELECT Object_FinalSUAProtocol.Id     AS Id
           , tmpUnit.Code                   AS AssortmentCode
           , tmpUnit.Name                   AS AssortmentName
           
      FROM Object AS Object_FinalSUAProtocol
      
           INNER JOIN ObjectDate AS ObjectDate_OperDate
                                 ON ObjectDate_OperDate.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectDate_OperDate.DescId = zc_ObjectDate_FinalSUAProtocol_OperDate()
                               
           INNER JOIN ObjectBlob AS ObjectBlob_Recipient
                                 ON ObjectBlob_Recipient.ObjectId = Object_FinalSUAProtocol.Id
                                AND ObjectBlob_Recipient.DescId = zc_objectBlob_FinalSUAProtocol_Assortment()

           INNER JOIN (SELECT T1.Id, T1.Code, T1.Name FROM gpSelect_Object_Unit (True, inSession) AS T1) AS tmpUnit
                                ON ','||ObjectBlob_Recipient.ValueData||',' LIKE '%,'||tmpUnit.Id::TVarChar||',%'
            
      WHERE Object_FinalSUAProtocol.DescId = zc_Object_FinalSUAProtocol()
        AND Object_FinalSUAProtocol.isErased = False
        AND ObjectDate_OperDate.ValueData >= inStartDate
        AND ObjectDate_OperDate.ValueData < inEndDate + INTERVAL '1 DAY'
      ORDER BY Object_FinalSUAProtocol.Id, tmpUnit.Name
      ;

     RETURN NEXT Cursor3;
          
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.03.21                                                       *
*/

-- тест
-- FETCH ALL "<unnamed portal 1>";
-- 
select * from gpReport_FinalSUAProtocol(inStartDate:= '01.02.2021', inEndDate:= '10.04.2021',  inSession := '3');