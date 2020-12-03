--- Function: gpSelect_MovementItem_DistributionPromoSign()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_DistributionPromoSign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_DistributionPromoSign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (UnitName        TVarChar
             , JuridicalName   TVarChar
             , RetailName      TVarChar
             , NumberRequests  Integer
             , NumberIssued    Integer
             , isErased        Boolean

              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
        WITH
        tmpMI AS (SELECT MI_Sign.Id
                       , MI_Sign.Amount::Integer                               AS MovementId
                       , MI_Sign.IsErased                                      AS isIssuedBy
       
                  FROM MovementItem AS MI_Sign
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                  )

      , tmpCheck AS (SELECT tmpMI.Id                   AS ID
                          , Movement.ID                AS MovementID
                          , tmpMI.isIssuedBy           AS isIssuedBy
                          , Movement.OperDate          AS OperDate
                          , Movement.Invnumber         AS Invnumber
                          , Object_Unit.ValueData      AS UnitName
                          , Object_Juridical.ValueData AS JuridicalName
                          , Object_Retail.ValueData    AS RetailName
                          , MovementFloat_TotalSumm.ValueData  AS TotalSumm
                     FROM tmpMI 
                     
                          LEFT JOIN Movement ON Movement.ID = tmpMI.MovementId
                          
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                          
                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                               ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                     )

           SELECT tmpCheck.UnitName     
                , tmpCheck.JuridicalName 
                , tmpCheck.RetailName  
                , count(*)::Integer                                                      AS NumberRequests
                , Sum(CASE WHEN tmpCheck.isIssuedBy = TRUE THEN 1 ELSE 0 END)::Integer   AS NumberIssued
                , False                                                                  AS isErased
           FROM tmpCheck
           
           
           GROUP BY tmpCheck.UnitName     
                , tmpCheck.JuridicalName 
                , tmpCheck.RetailName  ;
  
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.20                                                       *
*/


-- select * from gpSelect_MovementItem_DistributionPromoSign(inMovementId := 16406918 , inIsErased := 'False' ,  inSession := '3');

select * from gpSelect_MovementItem_DistributionPromoSign(inMovementId := 20428980  , inIsErased := 'False' ,  inSession := '3');