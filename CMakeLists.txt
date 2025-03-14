# SPDX-License-Identifier: Apache-2.0
# Copyright 2025 Nordic Semiconductor ASA

cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(go_idle)

target_sources(app PRIVATE src/main.c)
