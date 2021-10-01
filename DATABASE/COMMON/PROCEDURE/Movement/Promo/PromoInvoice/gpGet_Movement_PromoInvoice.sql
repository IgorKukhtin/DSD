-- Function: gpGet_Movement_PromoInvoice()

DROP FUNCTION IF EXISTS gpGet_Movement_PromoInvoice (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PromoInvoice(
    IN inMovementId        Integer  , -- ключ Документа
    IN inParentId          Integer  , -- акция
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , ParentId         Integer
             , OperDate         TDateTime
             , InvNumber        Integer
             , InvNumberFull    TVarChar
             , InvNumberPartner TVarChar
             , InvNumber_Parent TVarChar, InvNumber_ParentFull TVarChar
             , StatusCode       Integer
             , StatusName       TVarChar
             , BonusKindId      Integer
             , BonusKindName    TVarChar
             , PaidKindId       Integer
             , PaidKindName     TVarChar
             , ContractId       Integer
             , ContractCode     Integer
             , ContractName     TVarChar
             , JuridicalId      Integer
             , JuridicalName    TVarChar
             , TotalSumm        TFloat
             , Comment          TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbSignInternalId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
        -- Результат
        RETURN QUERY
        SELECT
            0                                                 AS Id
          , inParentId                                AS ParentId
          , inOperDate	                                      AS OperDate
          , CAST (NEXTVAL ('movement_PromoInvoice_seq') AS Integer)::Integer  AS InvNumber
          , ''  :: TVarChar                                   AS InvNumberFull
          , ''  :: TVarChar                                   AS InvNumberPartner
          , Movement_parent.InvNumber                         AS InvNumber_Parent
          , ('№ ' || Movement_parent.InvNumber || ' от ' || zfConvert_DateToString (Movement_parent.OperDate)  ) :: TVarChar AS InvNumber_ParentFull
          
          , Object_Status.Code               	              AS StatusCode
          , Object_Status.Name              		      AS StatusName

          , Object_BonusKind.Id                               AS BonusKindId
          , Object_BonusKind.ValueData                        AS BonusKindName
          , Object_PaidKind.Id                                AS PaidKindId
          , Object_PaidKind.ValueData                         AS PaidKindName
          , 0                                                 AS ContractId
          , 0                                                 AS ContractCode
          , ''  :: TVarChar                                   AS ContractName
          , 0                                                 AS JuridicalId
          , ''  :: TVarChar                                   AS JuridicalName
          , NULL::TFloat                                      AS TotalSumm
          , NULL::TVarChar                                    AS Comment
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Movement AS Movement_parent ON Movement_parent.Id = inParentId
             LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = 81959 -- Бонус
             LEFT JOIN Object AS Object_PaidKind  ON Object_PaidKind.Id  = zc_Enum_PaidKind_FirstForm()
        ;
    ELSE
        RETURN QUERY
        SELECT
               Movement.Id                                                 --Идентификатор
             , Movement.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_Promo)
             , Movement.OperDate
             , Movement.Invnumber::Integer
             , ('№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate)  ) :: TVarChar AS InvNumberFull
             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
             , Movement_parent.InvNumber              AS InvNumber_Parent
             , ('№ ' || Movement_parent.InvNumber || ' от ' || zfConvert_DateToString (Movement_parent.OperDate)  ) :: TVarChar AS InvNumber_ParentFull

             , Object_Status.ObjectCode               AS StatusCode         --код статуса
             , Object_Status.ValueData                AS StatusName         --Статус

             , Object_BonusKind.Id                    AS BonusKindId
             , Object_BonusKind.ValueData             AS BonusKindName
       
             , Object_PaidKind.Id                     AS PaidKindId
             , Object_PaidKind.ValueData              AS PaidKindName

             , Object_Contract.Id                     AS ContractId
             , Object_Contract.ObjectCode             AS ContractCode
             , Object_Contract.ValueData              AS ContractName

             , Object_Juridical.Id                    AS JuridicalId
             , Object_Juridical.ValueData             AS JuridicalName

             , MovementFloat_TotalSumm.ValueData      AS TotalSumm
             , MovementString_Comment.ValueData       AS Comment
       
           FROM Movement    
               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
               LEFT JOIN MovementLinkObject AS MovementLinkObject_BonusKind
                                            ON MovementLinkObject_BonusKind.MovementId = Movement.Id
                                           AND MovementLinkObject_BonusKind.DescId = zc_MovementLinkObject_BonusKind()
               LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MovementLinkObject_BonusKind.ObjectId
       
               LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

               LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                            ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                           AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

               LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
       
               LEFT JOIN MovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                             
               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
               LEFT JOIN Movement AS Movement_parent ON Movement_parent.Id = Movement.ParentId
           WHERE Movement.DescId = zc_Movement_PromoInvoice()
             AND Movement.Id = inMovementId
    ;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PromoInvoice (inMovementId:= 0, inParentId := 1, inOperDate:= '30.11.2015', inSession:= zfCalc_UserAdmin())
