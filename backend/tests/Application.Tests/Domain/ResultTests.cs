using Domain;
using FluentAssertions;

namespace Application.Tests.Domain;

public class ResultTests
{
    [Fact]
    public void Success_ShouldHaveIsSuccessTrue()
    {
        var result = Result.Success();
        result.IsSuccess.Should().BeTrue();
        result.Error.Should().BeNull();
    }

    [Fact]
    public void Failure_ShouldHaveIsSuccessFalse_AndContainError()
    {
        var result = Result.Failure("something went wrong");
        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("something went wrong");
    }

    [Fact]
    public void GenericSuccess_ShouldContainValue()
    {
        var result = Result<int>.Success(42);
        result.IsSuccess.Should().BeTrue();
        result.Value.Should().Be(42);
        result.Error.Should().BeNull();
    }

    [Fact]
    public void GenericFailure_ShouldHaveIsSuccessFalse_AndContainError()
    {
        var result = Result<int>.Failure("err");
        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Be("err");
        result.Value.Should().Be(default);
    }
}
