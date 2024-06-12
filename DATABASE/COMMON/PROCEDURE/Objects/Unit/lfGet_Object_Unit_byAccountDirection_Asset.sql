-- Function: lfGet_Object_Unit_byAccountDirection_Asset ()

-- DROP FUNCTION lfGet_Object_Unit_byAccountDirection_Asset (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Unit_byAccountDirection_Asset (IN inUnitId Integer)

RETURNS TABLE (UnitId Integer
             , AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar
             , AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar
              )
AS
$BODY$
  DECLARE vbAccountDirectionId Integer;
BEGIN
     vbAccountDirectionId :=
       (SELECT
              COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, ObjectLink_Unit_AccountDirection_two.ChildObjectId)
        FROM Object AS Object_Unit
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent8
                                  ON ObjectLink_Unit_Parent8.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Parent8.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent7
                                  ON ObjectLink_Unit_Parent7.ObjectId = ObjectLink_Unit_Parent8.ChildObjectId
                                 AND ObjectLink_Unit_Parent7.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent6
                                  ON ObjectLink_Unit_Parent6.ObjectId = ObjectLink_Unit_Parent7.ChildObjectId
                                 AND ObjectLink_Unit_Parent6.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent5
                                  ON ObjectLink_Unit_Parent5.ObjectId = ObjectLink_Unit_Parent6.ChildObjectId
                                 AND ObjectLink_Unit_Parent5.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent4
                                  ON ObjectLink_Unit_Parent4.ObjectId = ObjectLink_Unit_Parent5.ChildObjectId
                                 AND ObjectLink_Unit_Parent4.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent3
                                  ON ObjectLink_Unit_Parent3.ObjectId = ObjectLink_Unit_Parent4.ChildObjectId
                                 AND ObjectLink_Unit_Parent3.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent2
                                  ON ObjectLink_Unit_Parent2.ObjectId = ObjectLink_Unit_Parent3.ChildObjectId
                                 AND ObjectLink_Unit_Parent2.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent1
                                  ON ObjectLink_Unit_Parent1.ObjectId = ObjectLink_Unit_Parent2.ChildObjectId
                                 AND ObjectLink_Unit_Parent1.DescId = zc_ObjectLink_Unit_Parent()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent0
                                  ON ObjectLink_Unit_Parent0.ObjectId = ObjectLink_Unit_Parent1.ChildObjectId
                                 AND ObjectLink_Unit_Parent0.DescId = zc_ObjectLink_Unit_Parent()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = CASE    WHEN ObjectLink_Unit_Parent8.ChildObjectId IS NULL
                                                                                            THEN Object_Unit.Id

                                                                                        WHEN ObjectLink_Unit_Parent7.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent8.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent6.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent7.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent5.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent6.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent4.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent5.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent3.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent4.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent2.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent3.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent1.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent2.ChildObjectId

                                                                                        WHEN ObjectLink_Unit_Parent0.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent1.ChildObjectId

                                                                                        ELSE Object_Unit.Id

                                                                                   END
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection_two
                                 ON ObjectLink_Unit_AccountDirection_two.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_AccountDirection_two.DescId = zc_ObjectLink_Unit_AccountDirection()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND Object_Unit.Id     = inUnitId
       );

     RETURN QUERY 
        SELECT inUnitId AS UnitId
             , lfSelect.AccountGroupId
             , lfSelect.AccountGroupCode
             , lfSelect.AccountGroupName
             , vbAccountDirectionId AS AccountDirectionId
             , lfSelect.AccountDirectionCode
             , lfSelect.AccountDirectionName
        FROM (SELECT inUnitId AS UnitId) AS tmp
             LEFT JOIN lfSelect_Object_AccountDirection() AS lfSelect ON lfSelect.AccountDirectionId = vbAccountDirectionId
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_Unit_byAccountDirection_Asset (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 24.03.14                                        * add Level-0
 26.08.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM lfGet_Object_Unit_byAccountDirection_Asset (8386) -- ¡Ûı„‡ÎÚÂËˇ
-- SELECT * FROM Object LEFT JOIN  lfGet_Object_Unit_byAccountDirection_Asset (Id) AS lfGet ON 1=1 WHERE Object.DescId = zc_Object_Unit() ORDER BY ObjectCode
