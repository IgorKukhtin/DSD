--- Function: gpSelect_LoyaltySaveMoney_ChekInfo()


DROP FUNCTION IF EXISTS gpSelect_LoyaltySaveMoney_ChekInfo (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoyaltySaveMoney_ChekInfo(
    IN inId          Integer      , -- ключ Соднржимое документа
    IN inSummaCheck  TFloat       , --
    IN inSumma       TFloat       , --
   OUT outText       TVarChar     , -- Текс на чеке
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
    DECLARE vbRetailId Integer;
    DECLARE vbMovementId  Integer;
    DECLARE vbSummaRemainder TFloat;
    DECLARE vbStartPromo TDateTime;
    DECLARE vbEndPromo TDateTime;
    DECLARE vbStartSale TDateTime;
    DECLARE vbEndSale TDateTime;
    DECLARE vbChangePercent TFloat;
    DECLARE vbChangeSumma TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    outText := '';
    inSummaCheck  := COALESCE( inSummaCheck, 0);
    inSumma  := COALESCE( inSumma, 0);

    IF NOT EXISTS(SELECT Movement.Id
                  FROM MovementItem

                      INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
                                         AND Movement.DescId = zc_Movement_LoyaltySaveMoney()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()

                      INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                    ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                   AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                                   AND MovementLinkObject_Retail.ObjectId = vbRetailId

                  WHERE MovementItem.Id = inId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE)
    THEN
      RETURN;
    END IF;

    SELECT Movement.Id
        , (MovementItem.Amount -
           COALESCE(MIFloat_Summ.ValueData, 0))::TFloat                  AS SummaRemainder
        , MovementDate_StartPromo.ValueData                              AS StartPromo
        , MovementDate_EndPromo.ValueData                                AS EndPromo
        , MovementDate_StartSale.ValueData                               AS StartSale
        , MovementDate_EndSale.ValueData                                 AS EndSale
    INTO vbMovementId, vbSummaRemainder, vbStartPromo, vbEndPromo, vbStartSale, vbEndSale
    FROM MovementItem

        INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
                           AND Movement.DescId = zc_Movement_LoyaltySaveMoney()

        LEFT JOIN Object AS Object_Buyer ON Object_Buyer.Id = MovementItem.ObjectId
        LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                               ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id
                              AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()

        LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                    ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                   AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                               ON MovementDate_EndSale.MovementId = Movement.Id
                              AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()

    WHERE MovementItem.Id = inId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE;

    IF vbStartPromo > CURRENT_DATE OR vbEndSale < CURRENT_DATE
    THEN
      RETURN;
    END IF;

    IF vbSummaRemainder > 0
    THEN
      outText := 'Cума накопичено: '||Trim(to_char(COALESCE(vbSummaRemainder, 0), 'G999G999G999G990D00'));
    END IF;

    IF inSumma > 0
    THEN
      IF outText <> '' THEN outText := outText||CHR(13); END IF;
      outText := outText||'Знижка за чеком: '||Trim(to_char(COALESCE(inSumma, 0), 'G999G999G999G990D00'));
    END IF;

    vbChangeSumma := 0;
    IF vbEndPromo >= CURRENT_DATE AND inSummaCheck > 0
    THEN

      SELECT MIFloat_ChangePercent.ValueData  AS ChangePercent
      INTO vbChangePercent
      FROM MovementItem

           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                       ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                      AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.DescId = zc_MI_Sign()
        AND MovementItem.Amount <= inSummaCheck
        AND MovementItem.isErased = FALSE
      ORDER BY MovementItem.Amount DESC
      LIMIT 1;

      vbChangeSumma := ROUND(inSummaCheck * vbChangePercent / 100, 2);
      IF vbChangeSumma > 0
      THEN
        IF outText <> '' THEN outText := outText||CHR(13); END IF;
        outText := outText||'В накопичення: '||Trim(to_char(ROUND(inSummaCheck * vbChangePercent / 100, 2), 'G999G999G999G990D00'));
      END IF;
    END IF;

    IF outText <> '' THEN outText := outText||CHR(13); END IF;
    outText := outText||'Залишок: '||Trim(to_char(vbSummaRemainder - inSumma + vbChangeSumma, 'G999G999G999G990D00'));
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.01.20                                                       *
*/


-- select * from gpSelect_LoyaltySaveMoney_ChekInfo(inId := 310220361 , inSummaCheck := 300, inSumma := 10 ,  inSession := '3');