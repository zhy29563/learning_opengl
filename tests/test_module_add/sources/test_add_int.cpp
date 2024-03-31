#include "test_module_add_common_header.h"

using namespace ModuleAdd;

TEST(AddInt, BothAreaZero) { EXPECT_EQ(0, AddInt(0, 0)); }

TEST(AddInt, BothAreaNegative) { EXPECT_EQ(-3, AddInt(-1, -2)); }

TEST(AddInt, BothAreaPositive) { EXPECT_EQ(3, AddInt(1, 2)); }

TEST(AddInt, ZeroAndPositive) { EXPECT_EQ(2, AddInt(0, 2)); }

TEST(AddInt, ZeroAndNegative) { EXPECT_EQ(-2, AddInt(0, -2)); }

TEST(AddInt, PositiveAndNegative) { EXPECT_EQ(0, AddInt(2, -2)); }