-- Function: lpSelect_MI_IncomeFuel_Sign (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS lpSelect_MI_IncomeFuel_Sign (Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_IncomeFuel_Sign(
    IN inMovementId  Integer       -- ключ Документа
   
)
RETURNS TABLE (Id Integer
             , strSign   TVarChar
             , strSignNo TVarChar
              )
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbObjectDescId Integer;
  DECLARE vbObjectId Integer;  
BEGIN

   
     SELECT Movement.DescId                               AS MovementDescId
          , COALESCE(Object_To.DescId,0)                  AS ObjectDescId
          , COALESCE(MovementLinkObject_From.ObjectId,0)  AS ObjectId

     INTO vbMovementDescId, vbObjectDescId, vbObjectId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = inMovementId;

     
     RETURN QUERY 
     
     WITH 
     tmpSignInternal AS (SELECT * 
                             FROM lpSelect_Object_SignInternalItem (vbMovementDescId, vbObjectDescId, 0)
                             )
            
   , tmpMISign AS (SELECT MovementItem.ObjectId              AS SignInternalId
                        , MILO_Insert.ObjectId               AS InsertId
                        , Object_User.ValueData              AS InsertName
                   FROM MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                        ON MILO_Insert.MovementItemId = MovementItem.Id
                                                       AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                       LEFT JOIN Object AS Object_User ON Object_User.Id = MILO_Insert.ObjectId
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Sign()
                     AND MovementItem.isErased   = False
                     AND MovementItem.Amount <> 0
                    )
    , tmpSign AS (SELECT STRING_AGG  (tmpMISign.InsertName , ', ') AS strSign
                  FROM tmpMISign
                  )

   , tmpSignNo AS (SELECT  STRING_AGG  ( tmpSignInternal.UserName  , ', ') AS strSignNo
                        
                   FROM tmpSignInternal
                       LEFT JOIN tmpMISign ON tmpMISign.InsertId = tmpSignInternal.UserId
                                        AND tmpMISign.SignInternalId = tmpSignInternal.SignInternalId
                   WHERE COALESCE(tmpMISign.InsertId,0)=0
                   )

   SELECT inMovementId AS Id
        , tmpSign.strSign ::TVarChar
        , tmpSignNo.strSignNo ::TVarChar
   FROM tmpSign
       LEFT JOIN tmpSignNo ON 1=1
       
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.16         * 
 
*/

-- тест
-- SELECT * FROM lpSelect_MI_IncomeFuel_Sign (inMovementId:= 4135559 )
