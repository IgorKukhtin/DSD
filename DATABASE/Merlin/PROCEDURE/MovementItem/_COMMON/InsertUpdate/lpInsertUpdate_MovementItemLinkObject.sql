-- Function: lpInsertUpdate_MovementItemLinkObject

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemLinkObject (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemLinkObject(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementItemId        Integer           , -- ключ 
    IN inObjectId              Integer             -- ключ объекта
)
RETURNS Boolean
AS
$BODY$
BEGIN
    IF inObjectId = 0
    THEN
        inObjectId := NULL;
    END IF;

    -- изменить <свойство>
    UPDATE MovementItemLinkObject SET ObjectId = inObjectId WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

    -- если не нашли
    IF NOT FOUND AND inObjectId IS NOT NULL
    THEN
        -- вставить <свойство>
        INSERT INTO MovementItemLinkObject (DescId, MovementItemId, ObjectId)
                                    VALUES (inDescId, inMovementItemId, inObjectId);
    /*ELSE
        -- сохранили протокол - !!!ЛОВИМ ОШИБКУ!!!
        IF inDescId = zc_MILinkObject_Receipt()
        THEN
            IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.MovementId = 17266213)
            THEN
                RAISE EXCEPTION 'Ошибка.<%>  %  %  %', inObjectId
                , lfGet_Object_ValueData((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inMovementItemId AND MovementItem.MovementId = 17266213))
                , lfGet_Object_ValueData((SELECT M.ObjectId FROM MovementItemLinkObject AS M WHERE M.MovementItemId = inMovementItemId AND M.DescId = zc_MILinkObject_GoodsKind()))
                , lfGet_Object_ValueData((SELECT M.ObjectId FROM MovementItemLinkObject AS M WHERE M.MovementItemId = inMovementItemId AND M.DescId = zc_MILinkObject_GoodsKindComplete()))
                ;
            END IF;
            --
            PERFORM lpInsert_MovementItemProtocol (inMovementItemId, zc_Enum_Process_Auto_PrimeCost() :: Integer, FALSE);
        END IF;*/
    END IF;             

    RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemLinkObject (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * IF ... AND inObjectId IS NOT NULL
*/

-- тест
