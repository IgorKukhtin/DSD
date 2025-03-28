-- Function: gpGet_PromoCodeReceiving_ForSite()

DROP FUNCTION IF EXISTS gpGet_PromoCodeReceiving_ForSite (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_PromoCodeReceiving_ForSite (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PromoCodeReceiving_ForSite (
    IN inBayerName     TVarChar,   --
    IN inBayerPhone    TVarChar,   --
    IN inBayerEmail    TVarChar,   --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               GUID       TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , ChangePercent TFloat
             , PromoCodeId   Integer
             , PromoCodeName TVarChar
             , Comment       TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vCountGUID Integer;
   DECLARE vbIndex Integer;
   DECLARE vbId Integer;
   DECLARE vbGUID TVarChar;
BEGIN
    vbUserId := inSession;

    IF COALESCE (inBayerName, '') = '' OR
       COALESCE (inBayerPhone, '') = ''
    THEN
      RETURN;
    END IF;

    WITH
      tmpMovement AS (
         SELECT
             Movement.Id                                                    AS MovementId
         FROM Movement

            LEFT JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
            LEFT JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementBoolean AS MovementBoolean_BuySite
                                      ON MovementBoolean_BuySite.MovementId =  Movement.Id
                                     AND MovementBoolean_BuySite.DescId = zc_MovementBoolean_BuySite()

         WHERE Movement.DescId = zc_Movement_PromoCode()
           AND Movement.StatusId = zc_Enum_Status_Complete()
           AND MovementDate_StartPromo.ValueData <= current_date
           AND MovementDate_EndPromo.ValueData >= current_date
           AND COALESCE(MovementBoolean_Electron.ValueData, FALSE) = True
           AND COALESCE(MovementBoolean_BuySite.ValueData, FALSE) = False
         ORDER BY MovementDate_EndPromo.ValueData LIMIT 1)
         
/*         ,

      tmpMovementFloat AS (SELECT DISTINCT MovementFloat_MovementItemId.MovementId
                                  , MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                             FROM MovementFloat AS MovementFloat_MovementItemId
                             WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()) */

    SELECT
      PromoCode.MovementId           AS MovementId,
      MI_Sign.Id                     AS MovementItemID,
      MIString_GUID.ValueData        AS GUID
    INTO
      vbMovementID,
      vbMovementItemID,
      vbGUID
    FROM tmpMovement AS PromoCode
            INNER JOIN MovementItem AS MI_Sign ON MI_Sign.MovementId = PromoCode.MovementId
                                   AND MI_Sign.DescId = zc_MI_Sign()
                                   AND MI_Sign.isErased = FALSE

            INNER JOIN MovementItemString AS MIString_GUID
                                          ON MIString_GUID.MovementItemId = MI_Sign.Id
                                         AND MIString_GUID.DescId = zc_MIString_GUID()

/*            LEFT JOIN tmpMovementFloat  AS MovementFloat_MovementItemId
                                        ON MovementFloat_MovementItemId.MovementItemId = MI_Sign.Id */

            LEFT JOIN MovementItemString AS MIString_Bayer
                                         ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                        AND MIString_Bayer.DescId = zc_MIString_Bayer()

    WHERE /*COALESCE (MovementFloat_MovementItemId.MovementId, 0) = 0
      AND */ COALESCE (MIString_Bayer.ValueData, '') = ''
    LIMIT 1;

    IF vbMovementItemID IS NOT NULL
    THEN

      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Bayer(), vbMovementItemID, inBayerName);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerPhone(), vbMovementItemID, inBayerPhone);
      -- сохранили свойство <>
      IF COALESCE (inBayerEmail, '') <> ''
      THEN
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerEmail(), vbMovementItemID, inBayerEmail);
      END IF;
--      -- сохранили свойство <Примечание>
--      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemID, inComment);
      -- сохранили связь с <>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), vbMovementItemID, vbUserId);
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), vbMovementItemID, CURRENT_TIMESTAMP);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (vbMovementItemID, vbUserId, False);

      RETURN QUERY
       SELECT 
          vbGUID
        , MovementDate_StartPromo.ValueData  AS StartPromo
        , MovementDate_EndPromo.ValueData    AS EndPromo
        , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent
        , MovementLinkObject_PromoCode.ObjectId AS PromoCodeId
        , Object_PromoCode.ValueData            AS PromoCodeName
        , MovementString_Comment.ValueData      AS Comment
       from Movement AS M_PromoCode

            LEFT JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = M_PromoCode.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
            LEFT JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = M_PromoCode.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  M_PromoCode.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoCode
                                         ON MovementLinkObject_PromoCode.MovementId = M_PromoCode.Id
                                        AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
            LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = M_PromoCode.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                    
         WHERE M_PromoCode.ID = vbMovementID;
    END IF;
    
    IF vbMovementID IS NOT NULL 
    THEN
    
      SELECT Count(*) AS CountGUID
      INTO vCountGUID
      FROM MovementItem AS MI_Sign 

              LEFT JOIN MovementItemString AS MIString_Bayer
                                           ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                          AND MIString_Bayer.DescId = zc_MIString_Bayer()

      WHERE MI_Sign.MovementId = vbMovementID
        AND MI_Sign.DescId = zc_MI_Sign()
        AND MI_Sign.isErased = FALSE
        AND COALESCE (MI_Sign.Amount, 0) = 1
        AND COALESCE (MIString_Bayer.ValueData, '') = '';
           
        IF COALESCE (vCountGUID, 0) < 30 
        THEN

          vbIndex := 0;
  
          -- строим строчку для кросса
          WHILE (vbIndex < 100) LOOP
            vbIndex := vbIndex + 1;
      
            -- сохранили <Элемент документа>
            INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
                              VALUES (zc_MI_Sign(), Null, vbMovementID, 1, NULL) RETURNING Id INTO vbId;          

            -- генерируем новый GUID код
            vbGUID := (SELECT zfCalc_GUID());

            -- сохранили свойство <>
            PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
  
            -- сохранили связь с <>
            PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);
            -- сохранили свойство <>
            PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);

          END LOOP;
        END IF;
      END IF;
      
    
END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 12.09.18        *
 14.06.18        *
*/

-- select * from gpGet_PromoCodeReceiving_ForSite('gdfghdfhdfh', '6575487568', '', zfCalc_UserSite());