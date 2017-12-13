-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsert_Movement_PromoPartner (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_Movement_PromoPartner(
    IN inParentId              Integer    , -- главый документ маркетинга
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
       
    PERFORM gpInsertUpdate_Movement_PromoPartner (0, inParentId, tmp.JuridicalId, '', inSession)
    FROM 
        (SELECT Movement.Id                              AS Id
              , MovementLinkObject_Juridical.ObjectId    AS JuridicalId
         FROM Movement 
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
         WHERE Movement.ParentId = inParentId
           AND Movement.DescId = zc_Movement_PromoPartner()
           AND Movement.StatusId <> zc_Enum_Status_Erased()) AS tmpMI
        FULL JOIN 
         (SELECT 0 AS Id
               , Object_Juridical.Id AS JuridicalId
         FROM Object AS Object_Juridical
         WHERE Object_Juridical.Id IN (410822,    --"Аметрин "
                                       59610,     --"БаДМ"
                                       59612,     --"Вента"
                                       59611,     --"СП "Оптима-Фарм, ЛТД""
                                       183352,    --"Фармпланета"
                                       183353)    --"фито-лек"
         ) AS tmp ON  tmp.JuridicalId = tmpMI.JuridicalId
         WHERE tmpMI.Id IS NULL;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 13.10.17         *
*/