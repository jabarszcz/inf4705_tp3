#ifndef AlgoCotton1_H
#define AlgoCotton1_H

#include "TableAlgorithm.h"
#include "TableAndCompanies.h"

class AlgoCotton1 : public TableAlgorithm {
	virtual Solution solve(const Problem &problem,
		solve_cb_t callback);
	void setProblem(const Problem &problem, std::map<company_id_t, Company*>& companiesToPlace, std::vector<Table>& tables);
	void placeTheMandatories(size_t& tablesWithPeople, size_t& fullTables, std::vector<Table>& tables, std::map<company_id_t, Company*>& companiesToPlace, size_t& peopleToPlace);
	void recursiveSolving(size_t tablesWithPeople, size_t fullTables, size_t companyToAdd, size_t tableToAddTo, std::vector<Table> tables, std::map<company_id_t, Company*> companiesToPlace, int weight, size_t peopleToPlace, size_t& averagePerTable, solve_cb_t& callback);
public:
	AlgoCotton1();
	class factory : public TableAlgorithm::factory {
		virtual std::unique_ptr<TableAlgorithm> make();
	};
	static Solution bestSol;
};

#endif // AlgoCotton1H