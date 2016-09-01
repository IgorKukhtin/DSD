-- Function: gpSelect_MI_EntryAsset()

DROP FUNCTION IF EXISTS gpSelect_MI_EntryAsset (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_EntryAsset(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , AssetId Integer, AssetCode Integer, AssetName TVarChar
             , StorageId Integer, StorageName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , Amount TFloat
             , Comment TVarChar, PartionGoods TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_EntryAsset());
     vbUserId:= lpGetUserBySession (inSession);


     --
     RETURN QUERY
         WITH tmpMI AS (SELECT MovementItem.Id                                 AS Id
                             , COALESCE (MovementItem.ObjectId, 0)             AS AssetId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MILinkObject_Storage.ObjectId, 0)     AS StorageId
                             , COALESCE (MILinkObject_Unit.ObjectId, 0)        AS UnitId
                             , COALESCE (MILinkObject_Member.ObjectId, 0)      AS MemberId                           
                             , MovementItem.isErased
                      
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                                   ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                                                   ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
                     )
        -- Результат
        SELECT
             tmpMI.Id

           , Object_Asset.Id                 AS AssetId
           , Object_Asset.ObjectCode         AS AssetCode
           , Object_Asset.ValueData          AS AssetName

           , Object_Storage.Id               AS StorageId
           , Object_Storage.ValueData        AS StorageName

           , Object_Unit.Id                  AS UnitId
           , Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName

           , Object_Member.Id                AS MemberId
           , Object_Member.ObjectCode        AS MemberCode
           , Object_Member.ValueData         AS MemberName

           , tmpMI.Amount          :: TFloat AS Amount

           , MIString_Comment.ValueData        :: TVarChar AS Comment
           , MIString_PartionGoods.ValueData   :: TVarChar AS PartionGoods

           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMI.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  tmpMI.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN Object AS Object_Asset   ON Object_Asset.Id   = tmpMI.AssetId
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = tmpMI.StorageId
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpMI.UnitId
            LEFT JOIN Object AS Object_Member  ON Object_Member.Id  = tmpMI.MemberId
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 27.08.16         * 
*/

-- тест
-- SELECT * from gpSelect_MI_EntryAsset (4065094, FALSE, zfCalc_UserAdmin());
-- SELECT * from gpSelect_MI_EntryAsset (4065094, TRUE, zfCalc_UserAdmin());
