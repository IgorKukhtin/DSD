--- Function: gpSelect_MovementItem_PromoCodeSign()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeSign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCodeSign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , GUID       TVarChar
             , BayerName  TVarChar
             , BayerPhone TVarChar
             , BayerEmail TVarChar
             , Comment    TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , IsChecked  Boolean
             , isErased   Boolean
             
             , Count_Check         Integer
             , Invnumber_Check     Integer
             , OperDate_Check      TDateTime
             , UnitName_Check      TVarChar
             , JuridicalName_Check TVarChar
             , RetailName_Check    TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbIsOne Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    vbIsOne := COALESCE ( (SELECT MovementBoolean_One.ValueData
                           FROM MovementBoolean AS MovementBoolean_One
                           WHERE MovementBoolean_One.MovementId = inMovementId
                             AND MovementBoolean_One.DescId = zc_MovementBoolean_One())
                         , FALSE
                        ) :: Boolean;
        RETURN QUERY
        WITH
        tmpMI AS (SELECT MI_Sign.Id
                       , CASE WHEN MI_Sign.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                       , MI_Sign.IsErased
       
                  FROM MovementItem AS MI_Sign
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND (MI_Sign.isErased = FALSE or inIsErased = TRUE)
                  )
       -- для скорости сначала вібираем все zc_MovementFloat_MovementItemId      
      , tmpMovementFloat AS (SELECT MovementFloat_MovementItemId.MovementId
                                  , MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                             FROM MovementFloat AS MovementFloat_MovementItemId
                             WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                               AND vbIsOne = TRUE
                            )
      -- Документ чек, по идее должен быть 1 , но чтоб не задвоилось берем макс и считаем сколько чеков
      , tmpCheck_Mov AS (SELECT tmpMI.Id
                              , MAX (MovementFloat_MovementItemId.MovementId)   AS MovementId_Check
                              , COUNT (MovementFloat_MovementItemId.MovementId) AS Count_Check
                         FROM tmpMI
                              INNER JOIN tmpMovementFloat AS MovementFloat_MovementItemId 
                                                          ON MovementFloat_MovementItemId.MovementItemId = tmpMI.Id

                         GROUP BY tmpMI.Id
                         )

      , tmpCheck AS (SELECT tmpCheck_Mov.Id                     AS MI_Id
                          , tmpCheck_Mov.Count_Check            AS Count_Check
                          , Movement_Check.OperDate    AS OperDate
                          , Movement_Check.Invnumber   AS Invnumber
                          , Object_Unit.ValueData      AS UnitName
                          , Object_Juridical.ValueData AS JuridicalName
                          , Object_Retail.ValueData    AS RetailName
                     FROM tmpCheck_Mov
                                                 
                          LEFT JOIN Movement AS Movement_Check ON Movement_Check.Id = tmpCheck_Mov.MovementId_Check
                          
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
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
                     )

           SELECT MI_Sign.Id
                , MIString_GUID.ValueData       ::TVarChar AS GUID
                , MIString_Bayer.ValueData      ::TVarChar AS BayerName
                , MIString_BayerPhone.ValueData ::TVarChar AS BayerPhone
                , MIString_BayerEmail.ValueData ::TVarChar AS BayerEmail
                , MIString_Comment.ValueData    ::TVarChar AS Comment
                
                , Object_Insert.ValueData                  AS InsertName
                , Object_Update.ValueData                  AS UpdateName
                , MIDate_Insert.ValueData                  AS InsertDate
                , MIDate_Update.ValueData                  AS UpdateDate

                , MI_Sign.IsChecked
                , MI_Sign.IsErased
                -- данные из чека
                , tmpCheck.Count_Check          ::Integer   AS Count_Check         
                , tmpCheck.Invnumber            ::Integer   AS Invnumber_Check
                , tmpCheck.OperDate             ::TDateTime AS OperDate_Check 
                , tmpCheck.UnitName             ::TVarChar  AS UnitName_Check
                , tmpCheck.JuridicalName        ::TVarChar  AS JuridicalName_Check
                , tmpCheck.RetailName           ::TVarChar  AS RetailName_Check
                
           FROM tmpMI AS MI_Sign
               LEFT JOIN tmpCheck ON tmpCheck.MI_Id = MI_Sign.Id

               LEFT JOIN MovementItemString AS MIString_GUID
                                            ON MIString_GUID.MovementItemId = MI_Sign.Id
                                           AND MIString_GUID.DescId = zc_MIString_GUID()
               LEFT JOIN MovementItemString AS MIString_Bayer
                                            ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                           AND MIString_Bayer.DescId = zc_MIString_Bayer()
               LEFT JOIN MovementItemString AS MIString_BayerPhone
                                            ON MIString_BayerPhone.MovementItemId = MI_Sign.Id
                                           AND MIString_BayerPhone.DescId = zc_MIString_BayerPhone()
               LEFT JOIN MovementItemString AS MIString_BayerEmail
                                            ON MIString_BayerEmail.MovementItemId = MI_Sign.Id
                                           AND MIString_BayerEmail.DescId = zc_MIString_BayerEmail()
                                                      
               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MI_Sign.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MI_Sign.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
               LEFT JOIN MovementItemDate AS MIDate_Update
                                          ON MIDate_Update.MovementItemId = MI_Sign.Id
                                         AND MIDate_Update.DescId = zc_MIDate_Update()
  
               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = MI_Sign.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
               LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                ON MILO_Update.MovementItemId = MI_Sign.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
               LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
;
  
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 13.12.17         *
*/

--select * from gpSelect_MovementItem_PromoCodeSign(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');