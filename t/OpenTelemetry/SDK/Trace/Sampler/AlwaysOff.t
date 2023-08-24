#!/usr/bin/env perl

use Test2::V0 -target => 'OpenTelemetry::SDK::Trace::Sampler::AlwaysOff';
use OpenTelemetry::Constants -span_kind;
use OpenTelemetry::Trace;

is my $sampler = CLASS->new, object {
    prop isa => $CLASS;
}, 'Can construct sampler';

is $sampler->description, 'AlwaysOffSampler', 'Description is correct';

is $sampler->should_sample(
    context    => OpenTelemetry::Context->current,
    trace_id   => OpenTelemetry::Trace->generate_trace_id,
    kind       => SPAN_KIND_INTERNAL,
    name       => 'foo',
    attributes => {},
    links      => [],
) => object {
    call sampled   => F;
    call recording => F;
}, 'Result is neither sampled nor recording';

done_testing;
