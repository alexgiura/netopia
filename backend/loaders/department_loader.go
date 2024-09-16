package loaders

import (
	"backend/db"
	_err "backend/errors"
	"backend/models"
	"backend/util"
	"context"
	"github.com/graph-gophers/dataloader"
	"log"
	"strconv"
)

func fetchDepartments(ctx context.Context, dbProvider *db.Queries, keys dataloader.Keys) ([]*dataloader.Result, error) {

	ids := make([]string, len(keys))
	for i, key := range keys {
		ids[i] = key.String()
	}

	departments, err := fetchDepartmentsByDepartmentIds(ctx, dbProvider, ids)
	if err != nil {
		return nil, err
	}

	results := make([]*dataloader.Result, len(keys))
	for i, id := range ids {
		if deps, ok := departments[id]; ok {
			results[i] = &dataloader.Result{Data: deps}
		} else {
			results[i] = &dataloader.Result{Data: []*models.Department{}}
		}
	}

	return results, nil
}

func fetchDepartmentsByDepartmentIds(ctx context.Context, dbProvider *db.Queries, ids []string) (map[string][]*models.Department, error) {
	rows, err := dbProvider.GetParentDepartments(ctx, util.StringArrayToInt32Array(ids))
	if err != nil {
		log.Print("\"message\": failed to execute DBProvider.GetParentDepartments, \"error\": ", err.Error())
		return nil, _err.Error(ctx, "Failed to load currency", "DatabaseError")
	}

	departments := make(map[string][]*models.Department)

	for _, row := range rows {
		departmentID := strconv.Itoa(int(row.ChildID))
		department := &models.Department{
			ID:    int(row.ID),
			Name:  row.Name,
			Flags: int(row.Flags),
		}
		departments[departmentID] = append(departments[departmentID], department)
	}

	return departments, nil
}
