-- Function: gpUpdate_Object_Clear_Cat_5

DROP FUNCTION IF EXISTS gpUpdate_Object_Clear_Cat_5 (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Clear_Cat_5(
    IN inSession          TVarChar   -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN


   SELECT gpUpdate_Object_PartionGoods_Cat_5 (ObjectDate.ObjectId, TRUE, '3')
   FROM ObjectDate
        INNER JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                 ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ObjectDate.ObjectId
                                AND ObjectBoolean_PartionGoods_Cat_5.DescId = zc_ObjectBoolean_PartionGoods_Cat_5()
                                AND ObjectBoolean_PartionGoods_Cat_5.ValueData= TRUE
        INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = ObjectDate.ObjectId
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
        INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                            AND Container.Amount > 0
/*        LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementDescId =  zc_Movement_Check() 
                                       AND MovementItemContainer.ContainerId = ContainerLinkObject.ContainerId
        LEFT JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemID
                                                                 
        LEFT JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.ParentId
                                        AND MovementItemLinkObject.DescId = zc_MILinkObject_PartionDateKind()
                                        AND MovementItemLinkObject.ObjectId = zc_Enum_PartionDateKind_Cat_5() 
*/    WHERE ObjectDate.DescId = zc_ObjectDate_PartionGoods_Cat_5()
--     AND COALESCE (MovementItemLinkObject.MovementItemId, 0) = 0
     AND ObjectDate.ValueData < CURRENT_DATE - interval '30 day';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 14.08.19                                                       *
*/

-- òåñò
-- SELECT * FROM gpUpdate_Object_Clear_Cat_5 ('3');
                     
                     

