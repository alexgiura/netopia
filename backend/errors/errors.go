package errors

import (
	"context"
	"github.com/99designs/gqlgen/graphql"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/gqlerror"
)

func Error(ctx context.Context, message string, code string) error {
	path := graphql.GetPath(ctx)
	if path == nil {
		path = ast.Path{ast.PathName("$")}
	}
	return &gqlerror.Error{
		Message: message,
		Path:    path,
		Extensions: map[string]interface{}{
			"code": code,
		},
	}
}
