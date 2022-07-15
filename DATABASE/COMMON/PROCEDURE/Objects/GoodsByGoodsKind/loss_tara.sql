with tmp1 as 
(SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId 
     , Movement.Id

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
WHERE Movement.OperDate between '01.07.2022' and '01.08.2022'
  and Movement.DescID = zc_Movement_Sale()
) 



SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
     , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
     , Movement.Id
, MovementItem.Id
, coalesce (MILinkObject_Box.ObjectId , 0) , ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId

, lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), MovementItem.Id, ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId)

                          FROM tmp1 AS Movement

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                inner JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()


                                             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = Movement.GoodsPropertyId
                                                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
and ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId > 0


                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
AND MovementItem.ObjectId           = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                                             inner JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
AND MILinkObject_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId


                                left  JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                 ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Box.DescId = zc_MILinkObject_Box()


 where coalesce (MILinkObject_Box.ObjectId , 0) <> ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
order by  MovementItem.Id