-- Function: lfGet_Object_Unit_byProfitLossDirection ()

-- DROP FUNCTION lfGet_Object_Unit_byProfitLossDirection (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Unit_byProfitLossDirection (IN inUnitId Integer)

RETURNS TABLE (UnitId Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer)
AS
$BODY$
  DECLARE vbProfitLossGroupId Integer;
  DECLARE vbProfitLossDirectionId Integer;
BEGIN
     vbProfitLossDirectionId :=
       (SELECT
              ObjectLink_Unit_ProfitLossDirection.ChildObjectId
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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProfitLossDirection
                                 ON ObjectLink_Unit_ProfitLossDirection.ObjectId = CASE WHEN ObjectLink_Unit_Parent8.ChildObjectId IS NULL
                                                                                            THEN Object_Unit.Id
                                                                                        WHEN ObjectLink_Unit_Parent7.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent8.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent6.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent7.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent5.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent6.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent4.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent5.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent3.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent4.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent2.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent3.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent1.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent2.ObjectId
                                                                                        WHEN ObjectLink_Unit_Parent0.ChildObjectId IS NULL
                                                                                            THEN ObjectLink_Unit_Parent1.ObjectId
                                                                                   END
                                AND ObjectLink_Unit_ProfitLossDirection.DescId = zc_ObjectLink_Unit_ProfitLossDirection()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND Object_Unit.Id = inUnitId);

     -- –ÂÁÛÎ¸Ú‡Ú
     RETURN QUERY 
        SELECT inUnitId AS UnitId
             , (SELECT lfObject_ProfitLossDirection.ProfitLossGroupId FROM lfGet_Object_ProfitLossDirection (vbProfitLossDirectionId) AS lfObject_ProfitLossDirection) AS ProfitLossGroupId
             , vbProfitLossDirectionId AS ProfitLossDirectionId
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfGet_Object_Unit_byProfitLossDirection (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 24.03.14                                        * add Level-0
 26.08.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM lfGet_Object_Unit_byProfitLossDirection (8432)
