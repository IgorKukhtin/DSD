-- Function: gpGet_Movement_PromoSale()

DROP FUNCTION IF EXISTS gpGet_Movement_PromoSale (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PromoSale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inMask              Boolean  , -- добавить по маске
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id                Integer     --Идентификатор
             , InvNumber         Integer     --Номер документа
             , OperDate          TDateTime   --Дата документа
             , StatusCode        Integer     --код статуса
             , StatusName        TVarChar    --Статус     
             , PriceListId       Integer     --прайс лист
             , PriceListName     TVarChar    --Прайс лист
             , StartPromo        TDateTime   --На полке с
             , EndPromo          TDateTime   --На полке по
             , StartSale         TDateTime   --Дата отгрузки с
             , EndSale           TDateTime   --Дата отгрузки по
             , OperDateStart     TDateTime   --Дата с (расч. продаж в аналогичный период)
             , OperDateEnd       TDateTime   --Дата по (расч. продаж в аналогичный период)
             , ChangePercent     TFloat      --(-)% Скидки (+)% Наценки по договору
             , Comment           TVarChar    --Примечание
             , PersonalTradeId   Integer     --Ответственный представитель коммерческого отдела
             , PersonalTradeName TVarChar   --Ответственный представитель коммерческого отдела
             , PersonalId        Integer     --Ответственный представитель маркетингового отдела	
             , PersonalName      TVarChar    --Ответственный представитель маркетингового отдела	
             , InsertName        TVarChar
             , InsertDate        TDateTime
             , NotBudgPromoId    Integer
             , NotBudgPromoName  TVarChar
             , isNotBudgPromo    Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PromoSale());
    vbUserId:= lpGetUserBySession (inSession);

     -- создаем док по маске
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_PromoSale_Mask (ioId        := inMovementId
                                                     , inOperDate  := inOperDate
                                                     , inSession   := inSession); 
     END IF;

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Невозможно открыть пустой документ.';
    END IF;


    IF COALESCE (inMovementId, 0) = 0
    THEN
        -- Результат
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , CAST (NEXTVAL ('movement_PromoSale_seq') AS Integer)  AS InvNumber
          , inOperDate	                                      AS OperDate
          , Object_Status.Code                                AS StatusCode
          , Object_Status.Name                                AS StatusName 
          , Object_PriceList.Id                               AS PriceListId         --Прайс лист
          , Object_PriceList.ValueData                        AS PriceListName       --Прайс лист
          , NULL::TDateTime                                   AS StartPromo          --Дата начала акции
          , NULL::TDateTime                                   AS EndPromo            --Дата окончания акции
          , NULL::TDateTime                                   AS StartSale           --Дата начала отгрузки по акционной цене
          , NULL::TDateTime                                   AS EndSale             --Дата окончания отгрузки по акционной цене
          , NULL::TDateTime                                   AS OperDateStart       --Дата начала расч. продаж до акции
          , NULL::TDateTime                                   AS OperDateEnd         --Дата окончания расч. продаж до акции
          , NULL::TFloat                                      AS ChangePercent       --(-)% Скидки (+)% Наценки по договору
          , NULL::TVarChar                                    AS Comment             --Примечание
          , NULL::Integer                                     AS PersonalTradeId     --Ответственный представитель коммерческого отдела
          , NULL::TVarChar                                    AS PersonalTradeName   --Ответственный представитель коммерческого отдела
          , NULL::Integer                                     AS PersonalId          --Ответственный представитель маркетингового отдела	
          , NULL::TVarChar                                    AS PersonalName        --Ответственный представитель маркетингового отдела
          , Object_Insert.ValueData         ::TVarChar        AS InsertName
          , CURRENT_TIMESTAMP ::TDateTime                     AS InsertDate
          , 0                                                 AS NotBudgPromoId
          , NULL::TVarChar                                    AS NotBudgPromoName
          , CAST (FALSE AS Boolean)                           AS isNotBudgPromo
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT OUTER JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
        ;
    ELSE
        RETURN QUERY
        -- Результат
        SELECT Movement_PromoSale.Id                                             --Идентификатор
             , Movement_PromoSale.InvNumber :: Integer                           --Номер документа
             , Movement_PromoSale.OperDate                                       --Дата документа
             , Object_Status.ObjectCode        :: Integer  AS StatusCode
             , Object_Status.ValueData         :: TVarChar AS StatusName   
             , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --Прайс Лист
             , Object_PriceList.ValueData                  AS PriceListName      --Прайс Лист
             , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
             , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
             , MovementDate_StartSale.ValueData            AS StartSale
             , MovementDate_EndSale.ValueData              AS EndSale
             , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала 
             , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания 
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% Скидки (+)% Наценки по договору
             , MovementString_Comment.ValueData            AS Comment            --Примечание
             , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
             , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
             , MovementLinkObject_Personal.ObjectId        AS PersonalId         --Ответственный представитель маркетингового отдела
             , Object_Personal.ValueData                   AS PersonalName       --Ответственный представитель маркетингового отдела
             , Object_User.ValueData                       AS InsertName
             , MovementDate_Insert.ValueData               AS InsertDate
             , Object_NotBudgPromo.Id                      AS NotBudgPromoId
             , Object_NotBudgPromo.ValueData               AS NotBudgPromoName
             , COALESCE (MovementBoolean_NotBudgPromo.ValueData, FALSE) ::Boolean AS isNotBudgPromo
        FROM Movement AS Movement_PromoSale
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoSale.StatusId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                          ON MovementLinkObject_PriceList.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
             LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

             LEFT JOIN MovementDate AS MovementDate_StartSale
                                     ON MovementDate_StartSale.MovementId = Movement_PromoSale.Id
                                    AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
             LEFT JOIN MovementDate AS MovementDate_EndSale
                                     ON MovementDate_EndSale.MovementId = Movement_PromoSale.Id
                                    AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                    ON MovementDate_StartPromo.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                    ON MovementDate_EndPromo.MovementId =  Movement_PromoSale.Id
                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                     ON MovementFloat_ChangePercent.MovementId = Movement_PromoSale.Id
                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_PromoSale.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementBoolean AS MovementBoolean_NotBudgPromo
                                       ON MovementBoolean_NotBudgPromo.MovementId = Movement_PromoSale.Id
                                      AND MovementBoolean_NotBudgPromo.DescId = zc_MovementBoolean_NotBudgPromo()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_NotBudgPromo
                                          ON MovementLinkObject_NotBudgPromo.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_NotBudgPromo.DescId = zc_MovementLinkObject_NotBudgPromo()
             LEFT JOIN Object AS Object_NotBudgPromo ON Object_NotBudgPromo.Id = MovementLinkObject_NotBudgPromo.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                          ON MovementLinkObject_PersonalTrade.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
             LEFT JOIN Object AS Object_PersonalTrade
                              ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                          ON MovementLinkObject_Personal.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
             LEFT JOIN Object AS Object_Personal
                              ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_PromoSale.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                          ON MovementLinkObject_Insert.MovementId = Movement_PromoSale.Id
                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
        WHERE Movement_PromoSale.DescId = zc_Movement_PromoSale()
          AND Movement_PromoSale.Id = inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.26         *
*/

-- тест
-- select * from gpGet_Movement_PromoSale(inMovementId := 34902837 , inOperDate := ('30.07.2026')::TDateTime , inMask := 'False' ,  inSession := '9457');