---
title: Go Design Patterns - Singleton
date: '2023-05-07'
tags: ['go', 'singleton', 'design-patterns']
draft: true
summary: Hoe to implement a singleton pattern in go
---

# Singleton Design Pattern

The singleton pattern is restricts the instantiation of an object into a singular instance. This kind of pattern is used when you need to have a global instance of an object in all application. For example in logging you should only have one logger instantiated and configured in all your application, otherwise you can loose some logs.

## Lazy Initialization

The easiest way that you can implement a singleton pattern in go using a struct and a private variable that holds the instance of the struct. Also you need a function to get the singleton instance, or initialize it.

Example:

```go
package log

import (
	"sync"

	"go.uber.org/zap"
)

var instance *zap.Logger

func GetLoggerInstance() *zap.Logger {
	if instance == nil {
    instance, _ = zap.NewProduction()
  }
	return instance
```

And you can use it in your code simply calling:

```go
logger := log.GetLoggerInstance()
logger.Info("Hello World")
```

## Thread Safe Singleton

In order to avoid data races you need to have thread safety. For this you can use Go std library sync as you can see in the following example:

```go
package log

import (
	"sync"

	"go.uber.org/zap"
)

var (
	instance *zap.Logger
	once     sync.Once
)

func GetLoggerInstance() *zap.Logger {
	once.Do(func() {
		instance, _ = zap.NewProduction()
	})
	return instance
}
```

And you can use exactly as before:

```go
logger := log.GetLoggerInstance()
logger.Info("Hello World")
```
