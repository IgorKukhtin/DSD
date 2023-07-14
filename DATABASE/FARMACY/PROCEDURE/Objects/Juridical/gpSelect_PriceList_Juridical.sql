DROP FUNCTION IF EXISTS gpSelect_PriceList_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PriceList_Juridical(
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isSelect Boolean, isErased Boolean
                )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

    RETURN QUERY 
    WITH tmpJuridical AS (SELECT DISTINCT MovementLinkObject_Juridical.ObjectId  AS JuridicalId

                          FROM Movement
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                             ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                            AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                           WHERE Movement.DescId = zc_Movement_PriceList() 
                             AND Movement.OperDate > CURRENT_DATE - INTERVAL '1 YEAR')
                             
    SELECT Object_Juridical.Id           
         , Object_Juridical.ObjectCode  AS Code
         , Object_Juridical.ValueData   AS Name
         , False                        AS isSelect
         , Object_Juridical.isErased
    FROM tmpJuridical
     
         INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpJuridical. JuridicalId
         
    WHERE Object_Juridical.isErased = False
    ORDER BY Object_Juridical.ObjectCode;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 13.07.23                                                        * 
*/

select * from gpSelect_PriceList_Juridical(inSession := '3');    