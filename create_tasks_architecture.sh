#!/bin/bash

set -e

BASE_DIR="lib"

echo "📁 Creating Clean Architecture structure for Tasks feature..."

# App layer
mkdir -p $BASE_DIR/app

# Core layer
mkdir -p $BASE_DIR/core/errors
mkdir -p $BASE_DIR/core/utils

# Features / Tasks
mkdir -p $BASE_DIR/features/tasks/domain/entities
mkdir -p $BASE_DIR/features/tasks/domain/repositories
mkdir -p $BASE_DIR/features/tasks/domain/usecases

mkdir -p $BASE_DIR/features/tasks/data/models
mkdir -p $BASE_DIR/features/tasks/data/datasources
mkdir -p $BASE_DIR/features/tasks/data/repositories
mkdir -p $BASE_DIR/features/tasks/data/db

mkdir -p $BASE_DIR/features/tasks/presentation/bloc
mkdir -p $BASE_DIR/features/tasks/presentation/pages
mkdir -p $BASE_DIR/features/tasks/presentation/widgets

echo "✅ Architecture created successfully under lib/"
